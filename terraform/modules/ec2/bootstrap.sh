#!/bin/bash
set -e

echo "🚀 Starting EC2 bootstrap..."

# ============================================
# UPDATE SYSTEM
# ============================================

apt-get update -y

# ============================================
# INSTALL BASIC PACKAGES
# ============================================

apt-get install -y \
    python3 \
    python3-pip \
    git \
    curl \
    unzip \
    jq

# ============================================
# INSTALL DOCKER
# ============================================

curl -fsSL https://get.docker.com | sh

systemctl enable docker
systemctl start docker

# ============================================
# INSTALL DOCKER COMPOSE
# ============================================

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

apt-get install -y git

# ============================================
# CREATE APP DIRECTORY
# ============================================

mkdir -p /app

# ============================================
# OPTIONAL: CLONE REPOSITORY
# ============================================

# git clone https://github.com/Demystifier-git/Minishop-deployed-on-Ec2.git /app

echo "✅ Bootstrap completed successfully"