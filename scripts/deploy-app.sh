#!/bin/bash
sudo apt-get update 
sudo apt-get install nginx nodejs npm -y
cd ~
sudo git clone https://github.com/code2exe/Bento-Assessment.git
cd Bento-Assessment
sudo git checkout develop
sudo npm install
sudo npm install -g pm2
sudo npm start
sudo mv scripts/default /etc/nginx/sites-available/default
sudo nginx -s reload
sudo systemctl restart nginx
    