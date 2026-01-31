"""
Azure AI Demo Application

A Flask application demonstrating Azure OpenAI integration with
managed identity authentication and Key Vault secret retrieval.
"""

import logging
import os
from functools import lru_cache

from azure.identity import DefaultAzureCredential, ManagedIdentityCredential
from azure.keyvault.secrets import SecretClient
from flask import Flask, jsonify, request
from openai import AzureOpenAI

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Configuration
AZURE_OPENAI_ENDPOINT = os.environ.get("AZURE_OPENAI_ENDPOINT")
AZURE_OPENAI_DEPLOYMENT = os.environ.get("AZURE_OPENAI_DEPLOYMENT", "gpt-35-turbo")
AZURE_KEYVAULT_URL = os.environ.get("AZURE_KEYVAULT_URL")
API_VERSION = "2024-02-01"


def get_credential():
    """Get Azure credential based on environment."""
    if os.environ.get("WEBSITE_INSTANCE_ID"):
        # Running in Azure App Service - use Managed Identity
        return ManagedIdentityCredential()
    else:
        # Local development - use DefaultAzureCredential
        return DefaultAzureCredential()


@lru_cache(maxsize=1)
def get_openai_api_key() -> str:
    """
    Retrieve OpenAI API key from Azure Key Vault.
    Uses managed identity for Key Vault access.
    """
    if not AZURE_KEYVAULT_URL:
        raise RuntimeError("AZURE_KEYVAULT_URL environment variable is not set")
    
    credential = get_credential()
    client = SecretClient(vault_url=AZURE_KEYVAULT_URL, credential=credential)
    secret = client.get_secret("openai-api-key")
    
    logger.info("Successfully retrieved OpenAI API key from Key Vault")
    return secret.value


@lru_cache(maxsize=1)
def get_openai_client() -> AzureOpenAI:
    """
    Create and cache Azure OpenAI client.
    Uses API key retrieved from Key Vault.
    """
    api_key = get_openai_api_key()
    
    client = AzureOpenAI(
        azure_endpoint=AZURE_OPENAI_ENDPOINT,
        api_key=api_key,
        api_version=API_VERSION,
    )
    
    logger.info("Azure OpenAI client initialized")
    return client


@app.route("/health")
def health():
    """Health check endpoint."""
    return jsonify({
        "status": "healthy",
        "service": "azure-ai-demo",
        "openai_endpoint": AZURE_OPENAI_ENDPOINT is not None,
        "keyvault_configured": AZURE_KEYVAULT_URL is not None,
    })


@app.route("/")
def index():
    """Root endpoint with API information."""
    return jsonify({
        "name": "Azure AI Demo API",
        "version": "1.0.0",
        "endpoints": {
            "health": "/health",
            "chat": "/api/chat (POST)",
            "summarize": "/api/summarize (POST)",
        },
        "documentation": "https://github.com/jtg86/azure-ai-terraform-demo",
    })


@app.route("/api/chat", methods=["POST"])
def chat():
    """
    Chat endpoint using Azure OpenAI.
    
    Request body:
        {
            "message": "Your message here",
            "system_prompt": "Optional system prompt"
        }
    
    Response:
        {
            "response": "AI response",
            "model": "deployment name",
            "usage": { ... }
        }
    """
    try:
        data = request.get_json()
        
        if not data or "message" not in data:
            return jsonify({"error": "Message is required"}), 400
        
        user_message = data["message"]
        system_prompt = data.get("system_prompt", "You are a helpful assistant.")
        
        client = get_openai_client()
        
        response = client.chat.completions.create(
            model=AZURE_OPENAI_DEPLOYMENT,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_message}
            ],
            max_tokens=1000,
            temperature=0.7,
        )
        
        logger.info(
            "Chat completion successful. Tokens used: %d",
            response.usage.total_tokens
        )
        
        return jsonify({
            "response": response.choices[0].message.content,
            "model": AZURE_OPENAI_DEPLOYMENT,
            "usage": {
                "prompt_tokens": response.usage.prompt_tokens,
                "completion_tokens": response.usage.completion_tokens,
                "total_tokens": response.usage.total_tokens,
            }
        })
        
    except Exception as e:
        logger.exception("Error in chat endpoint")
        return jsonify({"error": str(e)}), 500


@app.route("/api/summarize", methods=["POST"])
def summarize():
    """
    Summarize text using Azure OpenAI.
    
    Request body:
        {
            "text": "Text to summarize",
            "max_length": 100  // optional
        }
    
    Response:
        {
            "summary": "Summarized text",
            "original_length": 500,
            "summary_length": 95
        }
    """
    try:
        data = request.get_json()
        
        if not data or "text" not in data:
            return jsonify({"error": "Text is required"}), 400
        
        text = data["text"]
        max_length = data.get("max_length", 100)
        
        client = get_openai_client()
        
        response = client.chat.completions.create(
            model=AZURE_OPENAI_DEPLOYMENT,
            messages=[
                {
                    "role": "system",
                    "content": f"Summarize the following text in approximately {max_length} words. Be concise and capture the key points."
                },
                {"role": "user", "content": text}
            ],
            max_tokens=500,
            temperature=0.5,
        )
        
        summary = response.choices[0].message.content
        
        logger.info(
            "Summarization successful. Original: %d chars, Summary: %d chars",
            len(text), len(summary)
        )
        
        return jsonify({
            "summary": summary,
            "original_length": len(text),
            "summary_length": len(summary),
            "usage": {
                "total_tokens": response.usage.total_tokens,
            }
        })
        
    except Exception as e:
        logger.exception("Error in summarize endpoint")
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    app.run(host="0.0.0.0", port=port, debug=os.environ.get("FLASK_DEBUG", False))
