# AWS Cloud Project: Web App & Business Intelligence Platform

This repository contains the Terraform Infrastructure as Code (IaC) configuration for deploying a cloud-native environment on AWS. It includes a scalable web application and a BI dashboard, both built for high availability and secure access.

---

## ☁️ Architecture Overview

The infrastructure uses the following AWS services:

- **Networking**
  - VPC with public and private subnets
  - Internet Gateway and NAT Gateway

- **Compute**
  - EC2 Auto Scaling Group for the web application
  - A standalone EC2 instance for the BI dashboard

- **Databases**
  - RDS MySQL for operational data
  - RDS PostgreSQL for analytics and Metabase internal storage

- **Load Balancing & SSL**
  - Application Load Balancer (ALB) with HTTPS support
  - Route 53 for DNS
  - AWS Certificate Manager (ACM) for SSL

- **Deployment**
  - Docker containers
  - EC2 User Data scripts for automation

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following:

- An AWS account with programmatic access configured (`aws configure`)
- Terraform v1.0+ installed
- Git installed
- DBeaver (or any other SQL client)
- An SSH Key Pair created in your AWS region and the `.pem` file placed in this repo's root directory
- A registered domain in AWS Route 53 (e.g., `yourdomain.com`)

---

### Setup Instructions

1. **Clone the repository**  
   ```bash
   git clone https://github.com/HinaFarheen/Devops_AWS_Project.git
   cd Devops_AWS_Project

2. **Initialize Terraform**
   ```bash
   terraform init

3. **Review the execution plan**
   ```bash
   terraform plan

5. **Apply the configuration**
   ```bash
   terraform apply

When prompted, type yes. The deployment may take several minutes.

### Accessing the Applications
Once deployment is complete:

- Web App: `https://app.yourdomain.com`

- Metabase (BI Tool): `https://bi.yourdomain.com`

Replace yourdomain.com with your actual domain name.

### Database Access (Private Subnets)
The RDS databases are private for security. To connect to them:

1. Start an SSH Tunnel with AWS SSM:
   ```bash
   aws ssm start-session \
     --target <BI_TOOL_EC2_INSTANCE_ID> \
     --document-name AWS-StartPortForwardingSession \
     --parameters 'portNumber=["5432"],localPortNumber=["5432"]'
   
Use 3306 for MySQL if connecting to the web app DB.

2. Open DBeaver and configure a connection:
   - Host: `localhost`

   - Port: 5432 (PostgreSQL) or 3306 (MySQL)

   - Username and Password set while setting up RDS instances
 
You can now run SQL scripts to populate dummy data.

### Setting Up Metabase
- PostgreSQL (bitool_db): This is pre-configured via EC2 startup script.

- MySQL (webappdb):

  - Login to Metabase as Admin

  - Navigate to Admin > Databases > Add Database

  - Enter RDS endpoint, port, and MySQL credentials from your terraform.tfvars

### Real-Time Data Demonstration
-- Create a dashboard using the MYSQL and PostgreSQL databases or use an existing one.

-- Insert new dummy rows in either RDS database using DBeaver

-- Refresh the Metabase dashboard

-- You’ll see updated charts and metrics instantly

### Application Repository
The React app used in this deployment is containerized and hosted separately. Make sure to replace this with your own fork:
[React App Repository](https://github.com/HinaFarheen/my_reactapp.git)

### Cleanup Resources
To delete all deployed AWS resources:
   ```bash 
   terraform destroy

Type yes when prompted. This helps avoid unnecessary billing.
