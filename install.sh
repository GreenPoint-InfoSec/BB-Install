#!/usr/bin/bash

OKBLUE='\033[94m'
OKRED='\033[91m'
OKGREEN='\033[92m'
OKORANGE='\033[93m'
RESET='\e[0m'
REGEX='^[0-9]+$'

echo -e "$OKGREEN┌──────────────────────────────────────────────────────────────┐"
echo -e "$OKGREEN│   ______                          ____          _         __ │"
echo -e "$OKGREEN│  / ____/_____ ___   ___   ____   / __ \ ____   (_)____   / /_│"
echo -e "$OKGREEN│ / / __ / ___// _ \ / _ \ / __ \ / /_/ // __ \ / // __ \ / __/│"
echo -e "$OKGREEN│/ /_/ // /   /  __//  __// / / // ____// /_/ // // / / // /_  │"
echo -e "$OKGREEN│\____//_/    \___/ \___//_/ /_//_/     \____//_//_/ /_/ \__/  │"
echo -e "$OKGREEN│                                                              │"
echo -e "$OKGREEN└──────────────────────────────────────────────────────────────┘"
echo -e "$RESET"
echo -e "$OKBLUE+ -- --=[ BB-Install by GreenPoint-InfoSec"
echo -e "$OKBLUE+ -- --=[ https://github.com/GreenPoint-InfoSec"
echo -e "$OKBLUE+ -- --=[ Usage ./install.sh [go archive file name e.g go1.17.5.linux-amd64.tar.gz]"
echo -e "$RESET"

cd ~

apt update && apt upgrade -y

apt install -y make \
    gcc \
    net-tools \
    vim \
    nmap \
    wget \
    ca-certificates \
    curl \
    gnupg \
    virtualenv \
    gobuster \
    nikto \
    iputils-ping


# Install Go

cd /tmp 
wget https://go.dev/dl/$1
rm -rf /usr/local/go && tar -C /usr/local -xzf $1
cd ~

export GOPATH=$HOME/go
echo $GOPATH
export PATH=$PATH:$GOPATH:/usr/local/go/bin
echo $PATH
echo "export GOPATH=$HOME/go" >> .bashrc
echo "export PATH=$PATH:$GOPATH:/usr/local/go/bin" >> .bashrc
source .bashrc

go version

# Notify
go install github.com/projectdiscovery/notify/cmd/notify@latest

# Amass
go get github.com/OWASP/Amass/v3/...

# Subfinder
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Github subdomains
go install github.com/gwen001/github-subdomains@master

# httprobe
go install github.com/tomnomnom/httprobe@master

#shuffledns
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@master

# api shodan
# go get github.com/incogbyte/shosubgo/apishodan
# go build main.go


mkdir tools && cd tools

# Clone my repos
git clone https://github.com/GreenPoint-InfoSec/Back-The-File-Up.git
git clone https://github.com/GreenPoint-InfoSec/Wordlists.git

# Eyewitness
git clone https://github.com/FortyNorthSecurity/EyeWitness.git

# Install Favfreak
git clone https://github.com/devanshbatham/FavFreak
cd FavFreak
virtualenv -p python3 env
source env/bin/activate
python3 -m pip install mmh3
deactivate
cd ~/tools

# Masscan
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make
# This puts the program in the masscan/bin subdirectory
make install 
cd ~/tools

# Sn1per
git clone https://github.com/GreenPoint-InfoSec/Sn1per
cd Sn1per
bash install.sh force
cd ~/tools

# Docker
cd ~
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
apt install -y docker-ce docker-ce-cli containerd.io

# Create Docker images


# Create dot files repo
# Move to relevant .config directory
