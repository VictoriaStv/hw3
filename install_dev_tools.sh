#!/bin/bash

set -e

echo "=== Перевірка та встановлення інструментів DevOps ==="


# 1. Встановлення Docker
if ! command -v docker &> /dev/null
then
    echo "Docker не встановлено. Встановлюємо..."
    sudo apt update
    sudo apt install -y \
        ca-certificates \
        curl \
        gnupg

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) \
      signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
else
    echo "Docker уже встановлений ✔"
fi

# 2. Встановлення Docker Compose

if ! command -v docker-compose &> /dev/null
then
    echo "Docker Compose не встановлено. Встановлюємо..."
    sudo curl -L "https://github.com/docker/compose/releases/download/2.29.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose уже встановлений ✔"
fi


# 3. Встановлення Python

if ! command -v python3 &> /dev/null
then
    echo "Python не встановлено. Встановлюємо..."
    sudo apt update
    sudo apt install -y python3 python3-pip
else
    echo "Python уже встановлений ✔"
fi

# 4. Встановлення Django

if ! pip3 show django &> /dev/null
then
    echo "Django не встановлено. Встановлюємо..."
    pip3 install django
else
    echo "Django уже встановлений ✔"
fi

echo "=== Всі інструменти встановлені успішно 🎉 ==="
