#!/bin/bash
sudo apt update
sudo apt install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Hello from Terraform</h1>" | sudo tee /var/www/html/index.html