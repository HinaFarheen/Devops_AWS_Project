#!/bin/bash
echo "Starting user data script for BI tool..."

# Update system packages
yum update -y
echo "System packages updated."

# Install necessary packages
yum install -y docker git
echo "Docker and Git installed."

# Start and enable Docker
systemctl start docker
systemctl enable docker
echo "Docker started and enabled."

# Add ec2-user to docker group
usermod -aG docker ec2-user
echo "ec2-user added to docker group."


# Create Metabase directory and volume mount path
mkdir -p /home/ec2-user/metabase/metabase-data
chown -R ec2-user:ec2-user /home/ec2-user/metabase
echo "Metabase directory created."

# Run Metabase container as ec2-user (with persistent volume and env vars)
su - ec2-user -c "docker run -d \
  --name metabase \
  -p 3000:3000 \
  -v /home/ec2-user/metabase/metabase-data:/metabase-data \
  -e MB_DB_TYPE=$db_type \
  -e MB_DB_HOST=$db_endpoint \
  -e MB_DB_PORT=5432 \
  -e MB_DB_DBNAME=$db_name \
  -e MB_DB_USER=$db_username \
  -e MB_DB_PASS=$db_password \
  --restart always \
  metabase/metabase:latest"

echo "Metabase container started without Docker Compose."

echo "User data script for BI tool finished."
