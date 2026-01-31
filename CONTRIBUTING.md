# Contributing to Azure AI Terraform Demo

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Development Setup

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Python](https://www.python.org/downloads/) >= 3.11
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Docker](https://www.docker.com/get-started) (optional)

### Local Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/jtg86/azure-ai-terraform-demo.git
   cd azure-ai-terraform-demo
   ```

2. Set up Python environment:
   ```bash
   cd app
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

3. Initialize Terraform:
   ```bash
   cd infra/environments/dev
   terraform init -backend=false
   ```

## Code Style

### Terraform

- Use `terraform fmt` before committing
- Follow [Terraform Best Practices](https://www.terraform-best-practices.com/)
- Add descriptions to all variables and outputs
- Use modules for reusable components

### Python

- Format code with `black`
- Lint with `ruff`
- Add type hints where possible
- Write docstrings for functions

## Pull Request Process

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Run tests and linting locally
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

### PR Requirements

- [ ] Terraform validates successfully
- [ ] Python linting passes
- [ ] Documentation updated if needed
- [ ] No secrets or sensitive data included

## Reporting Issues

Please use GitHub Issues to report bugs or request features. Include:

- Clear description of the issue
- Steps to reproduce (for bugs)
- Expected vs actual behavior
- Environment details (OS, versions, etc.)

## Questions?

Feel free to open an issue for any questions about the project.
