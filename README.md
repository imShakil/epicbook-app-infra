# EpicBook Infrastructure with Azure DevOps Pipeline

This repository contains the infrastructure as code (IaC) for the EpicBook application using Terraform and Azure DevOps pipelines for automated deployment on AWS.

## Architecture Overview

The infrastructure provisions:

- **VPC**: Custom Virtual Private Cloud with public/private subnets
- **EC2 Instance**: Ubuntu 22.04 server for application hosting
- **RDS Database**: PostgreSQL database in private subnets
- **Security Groups**: Network security configurations
- **SSH Key Pair**: For secure server access

## Prerequisites

- Azure DevOps account with pipeline access
- AWS account with appropriate permissions
- Self-hosted Azure DevOps agent (aws-ubuntu pool)
- SSH key pair for EC2 access

## Required Variable Groups

Configure these variable groups in Azure DevOps:

### terraform-variables

- `TF_PREFIX`: Resource naming prefix (default: epkbk)
- `TF_RDS_ADMIN`: Database admin username
- `TF_RDS_PASSWORD`: Database admin password

### aws-credentials

- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key
- `AWS_REGION`: AWS region (default: ap-southeast-1)

## Secure Files

Upload to Azure DevOps Library:

- `id_rsa.pub`: SSH public key for EC2 access

## Deployment

### Manual Trigger

The pipeline uses manual trigger only. To deploy:

1. Navigate to Azure DevOps Pipelines
2. Select the EpicBook infrastructure pipeline
3. Click "Run pipeline"
4. Configure pipeline parameters:
   - **Destroy infrastructure after deployment**: Check to deploy and immediately destroy
   - **Destroy existing infrastructure**: Check to only destroy existing infrastructure
5. Run the pipeline

### Pipeline Stages

#### Stage 1: terraformAction

- Configures AWS credentials
- Downloads SSH public key
- Creates terraform.tfvars
- Runs terraform init, plan, and apply
- Publishes state files as artifacts

#### Stage 2: ManualDestroy (Optional)

- Runs when destroy parameters are enabled
- Downloads previous state files (if available)
- Destroys all infrastructure
- Cleans up workspace

## Infrastructure Outputs

After successful deployment:

- **Public IP**: EC2 instance public IP address
- **RDS Endpoint**: Database connection endpoint

## Terraform Modules

Uses external modules from [tfmodules repository](https://github.com/imShakil/tfmodules.git):

- `aws/vpc`: Network infrastructure
- `aws/instance`: EC2 instance configuration
- `aws/rds`: RDS database setup

## Configuration

### Default Values

- Region: `ap-southeast-1`
- CIDR Block: `10.0.0.0/16`
- Instance: Ubuntu 22.04 LTS
- SSH Key Path: `~/.ssh/id_rsa.pub`

### Customization

Modify `terraform/variables.tf` to change default values or override via `terraform.tfvars`.

## Security Notes

- Database is deployed in private subnets
- Security groups restrict access appropriately
- SSH keys are managed securely through Azure DevOps
- AWS credentials are stored in variable groups

## Cleanup

To destroy infrastructure:

### Option 1: Deploy and Destroy

1. Run pipeline with "Destroy infrastructure after deployment" checked
2. Infrastructure will be created then immediately destroyed

### Option 2: Destroy Only

1. Run pipeline with "Destroy existing infrastructure" checked
2. Only the destroy stage will execute

### Option 3: Separate Destroy Pipeline

Use the `destroy-pipeline.yml` for dedicated infrastructure cleanup
