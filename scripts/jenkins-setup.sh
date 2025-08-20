# jenkins-setup.sh
# Installs Java 17 and the Jenkins CI/CD server.

#!/bin/bash
set -e

echo "--- Installing Java 17 (Jenkins dependency) ---"
sudo apt install openjdk-17-jre -y

echo "--- Installing Jenkins ---"
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y

echo "--- Starting and enabling Jenkins service ---"
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "--- Jenkins installation complete! ---"
echo "Access Jenkins at http://65.1.108.207:8080"
echo "Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
