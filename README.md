# AWS VPC Infrastructure with Terraform

Production-ready AWS VPC setup with public/private subnet architecture, NAT Gateway, and complete routing configuration.

## Architecture Overview

This Terraform configuration creates a fully isolated VPC with:

- **VPC**: Custom CIDR block with DNS support enabled
- **Public Subnets** (2 AZs): For NAT Gateway and future internet-facing resources
- **Private Subnets** (2 AZs): For application workloads (ECS, RDS, etc.)
- **Internet Gateway**: Public subnet internet access
- **NAT Gateway**: Outbound internet access for private subnets (ECR pulls, package downloads)
- **Elastic IP**: Static IP for NAT Gateway
- **Route Tables**: Separate routing for public and private subnets

## Design Principles

✓ **Multi-AZ deployment** - High availability across 2 availability zones  
✓ **Private-by-default** - Application workloads isolated in private subnets  
✓ **Least-privilege routing** - Public subnets can't route to private resources  
✓ **Production-ready** - Follows AWS Well-Architected Framework

## Infrastructure Diagram

```
                    Internet
                       |
                 [Internet Gateway]
                       |
        ┌──────────────┴──────────────┐
        |         Public Subnets       |
        |   (NAT Gateway only)         |
        |  10.0.1.0/24  10.0.2.0/24   |
        └──────────────┬──────────────┘
                  [NAT Gateway]
                       |
        ┌──────────────┴──────────────┐
        |        Private Subnets       |
        | (ECS, ALB, RDS, Redis)       |
        | 10.0.11.0/24  10.0.12.0/24  |
        └─────────────────────────────┘
```

## Usage

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured
- AWS credentials with VPC creation permissions

### Deploy

```bash
terraform init
terraform plan
terraform apply
```

### Outputs

After deployment, Terraform outputs:
- VPC ID
- Public subnet IDs (for NAT/ALB)
- Private subnet IDs (for ECS tasks)
- NAT Gateway ID
- Route table IDs

### Customize

Edit `variables.tf` to change:
- VPC CIDR block
- Subnet ranges
- AWS region
- Resource naming

## Files

- `main.tf` - VPC, subnets, gateways
- `routing.tf` - Route tables and associations
- `variables.tf` - Input variables
- `outputs.tf` - Exported values
- `versions.tf` - Provider configuration

## Cost Considerations

**Monthly cost estimate** (ap-south-1 region):
- NAT Gateway: ~$32/month + data transfer
- Elastic IP (attached): Free
- VPC/Subnets/Route Tables: Free

💡 **Cost optimization**: For dev/test environments, consider using a single NAT Gateway or NAT instances instead.

## Security

- No resources exposed to public internet by default
- Private subnets have no direct internet gateway route
- All outbound traffic from private subnets goes through NAT Gateway
- Network ACLs can be added for additional layer

## Use Cases

This VPC setup supports:
- ECS Fargate services behind internal ALB
- RDS databases in private subnets
- Redis/ElastiCache clusters
- Lambda functions in VPC
- Any workload requiring private subnet isolation

## Author

Built for production use in startup environments. Deployed across dev, test, preprod, and prod.
