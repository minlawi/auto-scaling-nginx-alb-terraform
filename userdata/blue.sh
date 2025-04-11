#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx

# Get the automatically assigned IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Create a custom index.html file
cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to Blue Environment!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
        background: blue;
        color: white;
    }
</style>
</head>
<body>
<h1>Welcome to nginx-server!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>This server is running on IP: <strong>$SERVER_IP</strong></p>

<p>For online documentation and support, please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
EOF

# Restart Nginx to apply changes
sudo systemctl restart nginx