#!/bin/bash

# Stop the script if any command fails
set -e

echo "Updating system and installing NGINX..."
sudo apt update -y
sudo apt install nginx -y

echo "Creating website directory..."
sudo mkdir -p /var/www/group5newsblog

echo "Cleaning old website files..."
sudo rm -rf /var/www/group5newsblog/*

# This is the "Magic Fix": We move into the website folder where your files actually are
cd /home/ubuntu/newsblog/website

echo "Copying website files to /var/www/..."
sudo cp html/index.html /var/www/group5newsblog/
sudo cp html/about.html /var/www/group5newsblog/
sudo cp -r css /var/www/group5newsblog/
sudo cp -r js /var/www/group5newsblog/

echo "Creating nginx config..."
sudo tee /etc/nginx/sites-available/group5newsblog > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name _;

    root /var/www/group5newsblog;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

echo "Enabling site and restarting NGINX..."
# Create the link to enable the site
sudo ln -sf /etc/nginx/sites-available/group5newsblog /etc/nginx/sites-enabled/group5newsblog
# Remove the default NGINX landing page
sudo rm -f /etc/nginx/sites-enabled/default

# Final checks
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

echo "Deployment completed successfully!"