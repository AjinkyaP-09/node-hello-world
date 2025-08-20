# CI/CD Pipeline for a Node.js Application
This repository contains the source code and documentation for a complete CI/CD and deployment pipeline for a "Hello World" Node.js application. The project was completed as part of the Junior DevOps Engineer assignment.

The infrastructure is hosted on an AWS EC2 t2.micro instance running Ubuntu, and the entire setup utilizes free-tier services.

### Live Application
 Live Application URL: https://devlogin-nextastra.ddns.net


## Architecture Overview
The pipeline automates the process of building, testing, and deploying the Node.js application.

1. Source Control: The application code is hosted on GitHub.

2. CI/CD Server: Jenkins, running on an EC2 instance, pulls the code from GitHub.

3. Build & Deploy: The Jenkins pipeline installs dependencies and uses PM2 to run the application as a background service.

4. Reverse Proxy: NGINX acts as a reverse proxy, handling SSL termination and forwarding traffic to the Node.js application.

5. Monitoring: AWS CloudWatch Agent collects and displays key server and application metrics (CPU, memory, disk, and logs).

## Screenshots
Successful Jenkins Pipeline
<img width="1919" height="746" alt="image" src="https://github.com/user-attachments/assets/a7b73528-0605-4978-b5df-f1c0b91a9a55" />

Live Application
<img width="748" height="221" alt="Screenshot 2025-08-20 153023" src="https://github.com/user-attachments/assets/39009607-2785-48fb-b96a-82f3c7689eef" />

CloudWatch Monitoring Dashboard
<img width="1919" height="1079" alt="Screenshot 2025-08-20 160135" src="https://github.com/user-attachments/assets/bcacdcef-9d6a-45df-abd1-644c76cf0ae2" />

## Detailed Deployment Steps
The entire setup was performed on a fresh Ubuntu EC2 instance. The process was as follows:

1. Server Preparation: Installed Git and Node.js (via NVM).

2. Application Validation: Cloned the repository, installed dependencies with npm install, and confirmed the app runs on port 8081.

3. Jenkins Installation: Installed Jenkins and its dependencies (Java 17). Configured the NodeJS plugin.

4. CI/CD Pipeline Creation: Created a Jenkins pipeline that automates cloning, dependency installation, and deployment using PM2.

3. Security Configuration: Implemented Matrix-based security in Jenkins to create admin and developer roles, restricting anonymous access.

4. NGINX and SSL: Installed NGINX and configured it as a reverse proxy. Used No-IP for a free domain and Let's Encrypt (via Certbot) to secure the site with SSL.

5. Monitoring Setup: Deployed the AWS CloudWatch Agent to capture and display server metrics (CPU, Memory, Disk) and application logs.

## Configuration Files
Jenkinsfile (CI/CD Pipeline)
```
pipeline {
    agent any

    tools {
        nodejs 'NodeJS'
    }

    stages {
        stage('1. Clone Your Repository') {
            steps {
                echo 'Cloning your forked node-hello-world repository...'
                git branch: 'main', url: 'https://github.com/AjinkyaP-09/node-hello-world.git'
            }
        }

        stage('2. Install Dependencies') {
            steps {
                echo 'Installing npm dependencies...'
                sh 'npm install'
            }
        }

        stage('3. Deploy Application') {
            steps {
                echo 'Deploying the application...'
                sh '''
                pm2 stop node-hello-world || true
                pm2 start app.js --name node-hello-world -f
                '''
            }
        }
    }
}
```

NGINX Server Block (/etc/nginx/sites-available/node-app)
```
server {
    server_name devlogin-nextastra.ddns.net;

    location / {
        proxy_pass http://localhost:8081;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/devlogin-nextastra.ddns.net/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/devlogin-nextastra.ddns.net/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = devlogin-nextastra.ddns.net) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name devlogin-nextastra.ddns.net;
    return 404; # managed by Certbot


}
```
## Scripts
All shell scripts used for the setup can be found in the scripts directory of this repository.
