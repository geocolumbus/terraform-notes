#!/bin/bash

export application_dir=/opt/webapp
mkdir $application_dir

# Install useful tools
yum upgrade -y
yum install -y tree vim git wget htop

# Install ATOP and SAR
amazon-linux-extras install epel -y
yum install sysstat atop --enablerepo=epel -y
sed -i 's/^INTERVAL=600.*/INTERVAL=60/' /etc/sysconfig/atop
sed -i -e 's|*/10|*/1|' -e 's|every 10 minutes|every 1 minute|' /etc/cron.d/sysstat

# Install aws cli v2
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
./aws/install
rm -rf aws awscli-exe-linux-x86_64.zip

# Install nginx
amazon-linux-extras enable nginx1
yum clean metadata
yum install -y nginx
systemctl enable nginx
systemctl start nginx

# Install python app
mkdir $application_dir/myproject
cd $application_dir/myproject || exit
python3 -m venv venv
source venv/bin/activate
pip3 install --upgrade pip
pip3 install wheel
pip3 install gunicorn flask

cat << 'EOF' > $application_dir/myproject/myproject.py
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "<h1 color='green'>Hello George!</h1>"

if __name__ == "__main__":
    app.run(host='0.0.0.0')
EOF

cat << 'EOF' > $application_dir/myproject/wsgi.py
from myproject import app

if __name__ == "__main__":
    app.run()
EOF

cat << 'EOF' > /etc/systemd/system/gunicorn.service
[Unit]
Description=gunicorn daemon
After=network.target

[Service]
User=root
Group=root
WorkingDirectory=/opt/webapp/myproject
Environment="PATH=/opt/webapp/myproject/venv/bin"
ExecStart=/opt/webapp/myproject/venv/bin/gunicorn --workers=3 --bind unix:/opt/webapp/myproject/myproject.sock wsgi:app

[Install]
WantedBy=multi-user.target
EOF

systemctl start gunicorn
systemctl enable gunicorn

cat << 'EOF' > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        server_name  myproject.server;

        location / {
            proxy_pass http://unix:/opt/webapp/myproject/myproject.sock;
        }
    }
}
EOF

cat << 'EOF' >> /etc/hosts
0.0.0.0 myproject.server
EOF

systemctl restart nginx

yum update -y