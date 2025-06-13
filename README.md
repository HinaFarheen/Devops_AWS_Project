# AWS Project: Web App & Business Intelligence Platform
This repository contains the Terraform Infrastructure as Code (IaC) setup for deploying a complete, cloud-native solution on Amazon Web Services (AWS). It provisions both a scalable web application and a Business Intelligence (BI) platform, with a focus on high availability, security, and automation.

## Architecture Overview
The infrastructure is built using core AWS services, broken down as follows:

- Networking: Custom VPC with public and private subnets, NAT Gateway, and Internet Gateway setup.

- Compute: Auto Scaling Group of EC2 instances for the web app, and a separate EC2 instance for the BI tool.

- Databases:

  - Amazon RDS (MySQL) – for web application data

  - Amazon RDS (PostgreSQL) – for analytical data and as Metabase’s internal DB

- Load Balancing: HTTPS-enabled Application Load Balancer (ALB)

- DNS & SSL: Route 53 for custom domain names and AWS Certificate Manager (ACM) for SSL certificates

- Containers & Deployment: Apps are containerized with Docker and deployed automatically using EC2 User Data scripts

## Getting Started
Follow these steps to deploy the entire environment.
### Prerequisites
Make sure you have the following installed and set up:

- An AWS account and an IAM user with the required permissions

- Terraform v1.0+

- Git

- DBeaver or your preferred SQL client

- A registered domain in Route 53 (e.g., yourdomain.com)

- A valid SSH key pair in your AWS EC2 dashboard — .pem file should be placed in the root of this project

### Setup Instructions
1. Clone the repository
```git clone https://github.com/HinaFarheen/Devops_AWS_Project.git
cd Devops_AWS_Project```
2. Initialize Terraform
```terraform init```
3. Review the execution plan
```terraform plan```
4. Apply the configuration
```terraform apply```
When prompted, type yes. The deployment may take several minutes.

### Accessing the Applications
Once deployment is complete:

- Web App: `https://app.yourdomain.com`

- Metabase (BI Tool): `https://bi.yourdomain.com`

Replace yourdomain.com with your actual domain name.

### Database Access (Private Subnets)
The RDS databases are private for security. To connect to them:

1. Start an SSH Tunnel with AWS SSM:
```aws ssm start-session \
  --target <BI_TOOL_EC2_INSTANCE_ID> \
  --document-name AWS-StartPortForwardingSession \
  --parameters 'portNumber=["5432"],localPortNumber=["5432"]'```
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
```terraform destroy```
Type yes when prompted. This helps avoid unnecessary billing.
