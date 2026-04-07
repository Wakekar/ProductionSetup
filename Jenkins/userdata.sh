#!/bin/bash
set -xe

# -----------------------
# UPDATE SYSTEM
# -----------------------
apt update -y
apt upgrade -y

apt install -y curl wget git unzip software-properties-common fontconfig openjdk-17-jdk

# -----------------------
# DOCKER
# -----------------------
apt install -y docker.io
systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu
usermod -aG docker jenkins || true

# -----------------------
# AWS CLI
# -----------------------
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install -y unzip
unzip awscliv2.zip
./aws/install

# -----------------------
# JENKINS INSTALL
# -----------------------
wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian binary/ > \
/etc/apt/sources.list.d/jenkins.list

apt update -y
apt install -y jenkins

# -----------------------
# INSTALL PLUGINS
# -----------------------
wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/latest/download/jenkins-plugin-manager.jar

java -jar jenkins-plugin-manager.jar \
  --plugin-file /tmp/plugins.txt \
  --plugin-download-directory /var/lib/jenkins/plugins

# -----------------------
# JCasC SETUP
# -----------------------
mkdir -p /var/lib/jenkins/casc_configs
cp /tmp/jenkins.yaml /var/lib/jenkins/casc_configs/

chown -R jenkins:jenkins /var/lib/jenkins

echo 'CASC_JENKINS_CONFIG=/var/lib/jenkins/casc_configs/jenkins.yaml' >> /etc/default/jenkins

# -----------------------
# ENV VARIABLES (PLACEHOLDER)
# -----------------------
echo 'DOCKER_USERNAME=${DOCKER_USERNAME}' >> /etc/environment
echo 'DOCKER_PASSWORD=${DOCKER_PASSWORD}' >> /etc/environment
echo 'AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}' >> /etc/environment
echo 'AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}' >> /etc/environment

# -----------------------
# START JENKINS
# -----------------------
systemctl enable jenkins
systemctl restart jenkins
