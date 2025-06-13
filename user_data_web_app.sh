#!/bin/bash
echo "Starting user data script for web app..."

# Update system packages
yum update -y
echo "System packages updated."

# Install necessary packages
yum install -y nginx docker git
echo "Nginx, Docker, Git installed."

# Start and enable Docker
systemctl start docker
systemctl enable docker
echo "Docker started and enabled."

# Add ec2-user to docker group
usermod -aG docker ec2-user
echo "ec2-user added to docker group."

# Clone GitHub repository
REPO_URL="https://github.com/HinaFarheen/my_reactapp.git"
APP_DIR="/home/ec2-user/webapp"
mkdir -p "$APP_DIR"
git clone "$REPO_URL" "$APP_DIR"
chown -R ec2-user:ec2-user "$APP_DIR"
echo "GitHub repository cloned to $APP_DIR."

# Build and run Docker container as ec2-user
su - ec2-user -c "cd $APP_DIR && docker build -t my-react-app ."
if [ $? -ne 0 ]; then
  echo "Docker build failed. Exiting."
  exit 1
fi
su - ec2-user -c "docker run -d -p 8080:80 --name react-web my-react-app"
echo "Docker container for web app built and running."

# Configure Nginx as a reverse proxy
cat <<EOF > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://localhost:8080;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF
echo "Nginx configuration updated."

systemctl start nginx
systemctl enable nginx
echo "Nginx started and enabled."

echo "User data script for web app finished."
