# initial-setup.sh
# Installs basic dependencies like Git, Node.js (via NVM), and PM2.

#!/bin/bash
set -e

echo "--- Updating system packages ---"
sudo apt update -y
sudo apt upgrade -y

echo "--- Installing Git ---"
sudo apt install git -y

echo "--- Installing Node Version Manager (NVM) and Node.js v18 ---"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install 18
nvm use 18

echo "--- Installing PM2 process manager globally ---"
sudo npm install pm2 -g

echo "--- Initial setup complete! ---"
