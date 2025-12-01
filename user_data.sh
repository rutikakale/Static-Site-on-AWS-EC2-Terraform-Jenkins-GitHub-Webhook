#!/bin/bash
set -e

# Update packages
dnf update -y

# Install nginx and git
dnf install -y nginx git

# Enable & start nginx
systemctl enable nginx
systemctl start nginx

# Remove default nginx html folder
rm -rf /usr/share/nginx/html/*

# Clone GitHub repo into nginx root
git clone https://github.com/rutikakale/Static-Site-on-AWS-EC2-Terraform-Jenkins-GitHub-Webhook.git /usr/share/nginx/html

# Set permissions
chown -R nginx:nginx /usr/share/nginx/html
chmod -R 755 /usr/share/nginx/html

# Restart nginx
systemctl restart nginx
