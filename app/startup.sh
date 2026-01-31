#!/bin/bash
# Startup script for Azure App Service

# Install dependencies
pip install -r requirements.txt

# Start the application
gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 4 --threads 2 app:app
