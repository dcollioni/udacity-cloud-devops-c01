# Udacity - Cloud DevOps - Course 1 Project
## Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions

1. Follow [Policy instructions](policy/README.md)
1. Follow [Packer instructions](packer/README.md)
1. Follow [Terraform instructions](terraform/README.md)

### Output
- Policy Definition and Policy Assignment are created on the Azure subscription
- Packer image `c01-image` is created in the `packer-rg` Resource Group on Azure
- Terraform plan is deployed in the `udacity-c01-rg` Resource Group on Azure
- Server will be available on a public DNS and public IP address as described in the [Terraform instructions](terraform/README.md)
