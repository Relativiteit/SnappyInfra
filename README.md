# SnappyInfra

This repository contains Terraform code to automate the setup of servers using DigitalOcean.

## Prerequisites

Before you can use this Terraform configuration, make sure you have the following:

- DigitalOcean account connected to your credit card.
- Your own domain.
- Terraform CLI installed on your machine.

## Getting Started

1. Clone this repository to your local machine.
2. Update the terraform.tfvars file with your DigitalOcean API token or use the -var CLI option to pass the token.
3. Run terraform init to initialize the working directory and download the necessary provider plugins.
4. Run terraform plan to see the execution plan and ensure everything is set up correctly.
5. If the plan looks good, run terraform apply and confirm by typing "yes" when prompted.
6. Terraform will create a new DigitalOcean Droplet based on the specified configuration.
7. Once the Droplet is created, you can access it via its public IP address or your configured domain.

## Customizing the Configuration

If you want to customize the Droplet configuration, you can modify the main.tf file. Here are a few options you can change:

- `image`: The operating system image used for the Droplet. You can find available options in the DigitalOcean API documentation.
- `name`: The name of the Droplet.
- `region`: The region where the Droplet will be deployed.
- `size`: The size of the Droplet in terms of CPU and memory.

## Destroying the Infrastructure

To destroy the created Droplet and clean up the resources, run `terraform destroy` and confirm by typing "yes" when prompted. This will remove the server and associated resources from DigitalOcean.

Note: Be cautious when using terraform destroy as it permanently deletes the resources. Make sure you have backed up any important data.
