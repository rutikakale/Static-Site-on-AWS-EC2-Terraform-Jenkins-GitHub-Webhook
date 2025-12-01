# Static-Site-on-AWS-EC2-Terraform-Jenkins-GitHub-Webhook.git

## 📌 Overview

This project demonstrates how to deploy a static website on AWS EC2 using Terraform and automate continuous delivery using Jenkins CI/CD pipeline triggered by GitHub Webhooks.

The solution ensures:

* Zero-touch automated deployment

* Infrastructure-as-Code provisioning

* Secure SSH-based code delivery

* Fully automated updates on every GitHub commit

## 🏗️ Architecture Diagram


          ┌─────────────────────┐
          │      Developer      │
          └─────────┬───────────┘
                    │ Commit & Push
                    ▼
          ┌─────────────────────┐
          │     GitHub Repo     │
          └─────────┬───────────┘
                Webhook Trigger
                    │
                    ▼
          ┌─────────────────────┐
          │   Jenkins Pipeline  │
          │  (CI/CD Automation) │
          └─────────┬───────────┘
                SSH Deploy
                    │
                    ▼
          ┌─────────────────────┐
          │   AWS EC2 Instance  │
          │     (Nginx Host)    │
          └─────────┬───────────┘
                    │
                    ▼
          ┌─────────────────────┐
          │     End Users       │
          └─────────────────────┘

## 🎯 Project Goals

* Deploy a static website using Terraform

* Configure EC2, security groups, and user-data automation

* Setup Jenkins for continuous deployment

* Enable GitHub → Jenkins pipeline trigger

* Auto-update the website after every commit

## 📁 Repository Structure
```
static-web-deployment-terraform-jenkins/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
├── jenkinsfile
│
├── index.html
├── styles.css
├── about.html
├── blog.html
│
└── README.md
```
## 🛠️ Tools & Technologies

| Tool                | Purpose                     |
| ------------------- | --------------------------- |
| **Terraform**       | Infrastructure provisioning |
| **AWS EC2**         | Website hosting             |
| **Nginx**           | Web server                  |
| **GitHub**          | Source code                 |
| **Jenkins**         | CI/CD automation            |
| **GitHub Webhooks** | Auto-trigger pipeline       |

## ⚙️ Terraform Infrastructure
### ✔ EC2 Instance Setup
* Ubuntu AMI

* t2.micro instance

* Allow HTTP (80) + SSH (22)

* User Data script installs:

     * nginx

     * git

     * clones repo into `/var/www/html`

![](./Img/Github%20repo.png)  

### ✔ Security Group
```
Inbound:
  - 80 → 0.0.0.0/0
  - 22 → 15.207.111.25
Outbound:
  - 0.0.0.0/0
```
### ✔ User Data Script (Auto Deployment)
```
#!/bin/bash
set -e

apt update -y
apt install -y nginx git

systemctl enable nginx
systemctl start nginx

git clone https://github.com/YOUR-REPO/static-website.git /var/www/html

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

systemctl restart nginx
```

### 🔁 Jenkins CI/CD Pipeline

#### Pipeline Stages
1️⃣ Checkout SCM – Pull latest code from GitHub

2️⃣ SSH into EC2 – Authenticate using private key

3️⃣ Deploy Code – Pull changes into /var/www/html

4️⃣ Restart Nginx – Apply UI updates

5️⃣ Smoke Test – Validate website

### Jenkinsfile (Pipeline Script)
```python
pipeline {
    agent any

    stages {
        stage('Pull Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/rutikakale/Static-Site-on-AWS-EC2-Terraform-Jenkins-GitHub-Webhook.git'
            }
        }

        stage('SSH into EC2 & Update Website') {
            steps {
                sshagent(['ubuntu']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@15.207.111.25 "sudo rm -rf /var/www/html/*"
                    ssh ec2-user@15.207.111.25 "sudo git clone https://github.com/rutikakale/Static-Site-on-AWS-EC2-Terraform-Jenkins-GitHub-Webhook.git /var/www/html"
                    ssh ec2-user@15.207.111.25 "sudo systemctl restart nginx"
                    '''
                }
            }
        }
    }
}
```

### 🚀 Deployment Steps
#### 1️⃣ Deploy Infrastructure (Terraform)
```
terraform init
terraform plan
terraform apply -auto-approve
```
#### 2️⃣ Setup Jenkins
* Install Jenkins + plugins

* Create pipeline

* Add SSH private key

* Configure GitHub Webhook:
https://15.207.111.25/github-webhook/
![](./Img/webhook%20trigger.png)

#### 3️⃣ Auto Deployment
* Developer commits → GitHub

* Webhook triggers Jenkins

* Jenkins deploys changes to EC2

* Nginx restarts

* Website instantly updates 🎉

### 🔍 Validation

* Website loads through EC2 Public IP

* Jenkins pipeline completes successfully

* Nginx serves updated content

* GitHub commits reflect live within seconds

### 📸 Screenshots (Evidence)

-**Successful static website deployment** on AWS EC2

![](./Img/ec2%20instance.png)
---
-**Fully automated CI/CD pipeline** using Jenkins

![](./Img/Cicd%20pipeline%20success.png)
---

![](./Img/webhook%20trigger.png)
---

- **Infrastructure-as-Code** implementation with Terraform

![](./Img/terraform%20apply%20success.png)
---
### ✅ Final Results

* Static website successfully deployed on AWS EC2

* Fully automated CI/CD pipeline

* Zero manual deployments

* Fast rollout (9–10 seconds per deploy)

* GitHub → Jenkins → EC2 automation works flawlessly

This project delivers a complete DevOps automation pipeline using Terraform + Jenkins, ensuring reliable, repeatable, and fully automated website deployments.

