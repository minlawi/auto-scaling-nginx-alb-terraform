#!/bin/bash

# Update and install Apache
sudo apt update -y
sudo apt install apache2 -y

# Get the instance's local IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Create the HTML content with the IP address
cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>BLUE</title>
</head>
<body style="background-color:green; color:white;">
    <h1>Hello from GREEN Environment</h1>
    <p>Server IP: $IP_ADDRESS</p>
</body>
</html>
EOF

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl restart apache2

echo "Welcome to Green Apache Server"