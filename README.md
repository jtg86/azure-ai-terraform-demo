# Azure AI Infrastructure with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-purple.svg)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Azure-Cloud-blue.svg)](https://azure.microsoft.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A production-ready Terraform project demonstrating Infrastructure as Code (IaC) best practices for deploying AI-powered applications on Microsoft Azure.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Azure Cloud                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐   │
│  │   Azure      │  │   Azure      │  │   Azure OpenAI       │   │
│  │   Key Vault  │  │   Monitor    │  │   Service            │   │
│  │   (Secrets)  │  │   (Logs)     │  │   (GPT-4 / GPT-3.5)  │   │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘   │
│         │                 │                      │               │
│         └────────────┬────┴──────────────────────┘               │
│                      │                                           │
│              ┌───────▼────────┐                                  │
│              │  Azure App     │                                  │
│              │  Service       │◄─────── Users                    │
│              │  (Python API)  │                                  │
│              └────────────────┘                                  │
└─────────────────────────────────────────────────────────────────┘
```

## ✨ Features

- **Modular Terraform Design** - Reusable modules for each Azure service
- **Multi-Environment Support** - Separate configurations for dev/prod
- **Azure OpenAI Integration** - Pre-configured GPT model deployments
- **Security Best Practices** - Key Vault for secrets, managed identities
- **Observability** - Azure Monitor with Log Analytics workspace
- **CI/CD Pipeline** - GitHub Actions for automated deployments
- **Cost Optimization** - Environment-specific SKU selections

## 📁 Project Structure

```
.
├── infra/
│   ├── modules/
│   │   ├── openai/          # Azure OpenAI Service module
│   │   ├── app-service/     # App Service with managed identity
│   │   ├── key-vault/       # Key Vault for secrets management
│   │   └── monitoring/      # Log Analytics & Application Insights
│   └── environments/
│       ├── dev/             # Development environment
│       └── prod/            # Production environment
├── app/                     # Sample Python AI application
├── .github/workflows/       # CI/CD pipelines
└── README.md
```

## 🚀 Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with OpenAI access enabled

### Deployment

1. **Clone the repository**
   ```bash
   git clone https://github.com/jtg86/azure-ai-terraform-demo.git
   cd azure-ai-terraform-demo
   ```

2. **Authenticate with Azure**
   ```bash
   az login
   az account set --subscription "YOUR_SUBSCRIPTION_ID"
   ```

3. **Initialize and deploy (dev environment)**
   ```bash
   cd infra/environments/dev
   terraform init
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

4. **Deploy the application**
   ```bash
   cd ../../../app
   az webapp deploy --resource-group rg-ai-demo-dev --name <app-name> --src-path .
   ```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `ARM_SUBSCRIPTION_ID` | Azure Subscription ID | Yes |
| `ARM_TENANT_ID` | Azure AD Tenant ID | Yes |
| `ARM_CLIENT_ID` | Service Principal ID | CI/CD only |
| `ARM_CLIENT_SECRET` | Service Principal Secret | CI/CD only |

### Terraform Variables

See [`infra/environments/dev/terraform.tfvars.example`](infra/environments/dev/terraform.tfvars.example) for all available variables.

## 🧪 Testing the AI Endpoint

After deployment, test the API:

```bash
curl -X POST https://<app-name>.azurewebsites.net/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello, AI!"}'
```

## 📊 Cost Estimation

| Environment | Estimated Monthly Cost |
|-------------|----------------------|
| Development | ~$50-100 |
| Production  | ~$200-500 |

*Costs vary based on usage. Azure OpenAI is billed per token.*

## 🔐 Security Features

- ✅ Managed Identity for service-to-service auth
- ✅ Key Vault for secret storage
- ✅ HTTPS-only enforcement
- ✅ Network restrictions (configurable)
- ✅ RBAC with least-privilege access

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) first.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Jan Tommy Zonneveld**
- GitHub: [@jtg86](https://github.com/jtg86)

---

*Built with ❤️ using Terraform and Azure*
