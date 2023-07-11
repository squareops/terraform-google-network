#!/bin/bash
echo "bootstrapping Bastion Server with Pritunl"
sudo apt update
sudo apt --assume-yes install wget vim curl gnupg2 software-properties-common apt-transport-https ca-certificates lsb-release
echo "deb https://repo.pritunl.com/stable/apt jammy main" | sudo tee /etc/apt/sources.list.d/pritunl.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list
sudo apt update
sudo apt --assume-yes install libssl1.1
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update && sudo apt --assume-yes install pritunl mongodb-org
sudo systemctl start pritunl mongod
sudo systemctl enable pritunl mongod
#Stop Pritunl
sudo systemctl stop pritunl mongodb
sleep 10

#Set path for MongoDB:
echo "Set path for MongoDB..."
sudo pritunl set-mongodb mongodb://localhost:27017/pritunl

sudo systemctl start pritunl mongodb

sudo pritunl setup-key > setup-key.txt
echo "Set-up Key--->"
cat setup-key.txt
sudo pritunl default-password > password.txt
echo "Default password--->"
cat password.txt
