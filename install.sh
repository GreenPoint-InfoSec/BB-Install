#!/usr/bin/bash

OKBLUE='\033[94m'
OKRED='\033[91m'
OKGREEN='\033[92m'
OKORANGE='\033[93m'
RESET='\e[0m'
REGEX='^[0-9]+$'

echo -e "$OKGREEN"
echo -e "$OKGREEN   ______                          ____          _         __ "
echo -e "$OKGREEN  / ____/_____ ___   ___   ____   / __ \ ____   (_)____   / /_"
echo -e "$OKGREEN / / __ / ___// _ \ / _ \ / __ \ / /_/ // __ \ / // __ \ / __/"
echo -e "$OKGREEN/ /_/ // /   /  __//  __// / / // ____// /_/ // // / / // /_  "
echo -e "$OKGREEN\____//_/    \___/ \___//_/ /_//_/     \____//_//_/ /_/ \__/  "
echo -e "$OKGREEN"
echo -e "$OKGREEN"
echo -e "$RESET"
echo -e "$OKBLUE+ -- --=[ BB-Install by GreenPoint-InfoSec"
echo -e "$OKBLUE+ -- --=[ https://github.com/GreenPoint-InfoSec"
echo -e "$OKBLUE+ -- --=[ Usage ./install.sh [go archive file name e.g go1.17.5.linux-amd64.tar.gz]"
echo -e "$RESET"

if [ -z $1 ]; then
    echo -e "$OKRED Please specify the go file to download!"
    echo -e "$OKRED The latest version is go1.17.5.linux-amd64.tar.gz"
    echo -e "$OKRED Check https://go.dev/dl/ for the latest version!"
    echo -e "$RESET"
    exit 1
fi

cd ~

echo -e "$OKGREEN[*] Installing Dependencies... $RESET"
apt install -y build-essential \
    make \
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
    iputils-ping \
    sudo \
    whois \
    nano \
    python3 \
    python3-pip \
    perl \
    dnsutils \
    zsh \
    tmux \
    awscli \
    sqlmap    
sleep 1

# Install Go
echo -e "$OKGREEN[*] Installing Go... $RESET"
cd /tmp 
wget https://go.dev/dl/$1
rm -rf /usr/local/go && tar -C /usr/local -xzf $1
cd ~

export GOPATH=$HOME/go
echo $GOPATH
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
echo $PATH
echo "export GOPATH=$HOME/go/bin" >> .bashrc
echo "export PATH=$PATH:$GOPATH:/usr/local/go/bin" >> .bashrc
source .bashrc

echo -e "$OKGREEN"
go version
echo -e "$RESET"

# Notify
echo -e "$OKGREEN[*] Installing Notify... $RESET"
go install github.com/projectdiscovery/notify/cmd/notify@latest

# Amass
echo -e "$OKGREEN[*] Installing amass... $RESET"
go get github.com/OWASP/Amass/v3/...

# Subfinder
echo -e "$OKGREEN[*] Installing Subfinder... $RESET"
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Github subdomains
echo -e "$OKGREEN[*] Installing Github-subdomains... $RESET"
go install github.com/gwen001/github-subdomains@master

# httprobe
echo -e "$OKGREEN[*] Installing httprobe... $RESET"
go install github.com/tomnomnom/httprobe@master

#shuffledns
echo -e "$OKGREEN[*] Installing ShuffleDNS... $RESET"
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@master

# api shodan
echo -e "$OKGREEN[*] Installing Shosubgo... $RESET"
go get github.com/incogbyte/shosubgo
go build main.go


mkdir tools && cd tools

# Clone my repos
echo -e "$OKGREEN[*] Cloning GreenPoint-InfoSec Repositories... $RESET"
git clone https://github.com/GreenPoint-InfoSec/Back-The-File-Up.git
cd ~/tools/Back-The-File-Up
chmod +x backup.sh
ln -sf ~/tools/Back-The-File-Up/backup.sh /usr/local/bin/backup
cd ~/tools

git clone https://github.com/GreenPoint-InfoSec/Wordlists.git

# Eyewitness
echo -e "$OKGREEN[*] Installing Eyewitness... $RESET"
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd ~/tools/EyeWitness/Python/setup
chmod +x setup.sh
bash setup.sh
cd ~/tools

# Hunter.sh
echo -e "$OKGREEN[*] Cloning Hunter... $RESET"
git clone https://github.com/null-p4n/hunter.sh.git


# XSSStrike
echo -e "$OKGREEN[*] Installing XSStrike... $RESET"
git clone https://github.com/s0md3v/XSStrike.git
cd XSStrike
pip3 install -r requirements.txt 
chmod +x xsstrike.py
ln -sf ~/tools/XSStrike/xsstrike.py /usr/local/bin/xsstrike
cd ~/tools

# Joomscan
echo -e "$OKGREEN[*] Installing Joomscan... $RESET"
git clone https://github.com/rezasp/joomscan.git 
cd joomscan/ 
chmod +x joomscan.pl
ln -sf ~/tools/joomscan/joomscan.pl /usr/local/bin/joomscan
cd ~/tools

# Install Favfreak
echo -e "$OKGREEN[*] Installing Favfreak... $RESET"
git clone https://github.com/devanshbatham/FavFreak
cd FavFreak
virtualenv -p python3 env
source env/bin/activate
python3 -m pip install mmh3
deactivate
cd ~/tools

# Masscan
echo -e "$OKGREEN[*] Installing Masscan... $RESET"
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make
# This puts the program in the masscan/bin subdirectory
make install 
cd ~/tools

# Sn1per
echo -e "$OKGREEN[*] Installing Sn1per... $RESET"
git clone https://github.com/GreenPoint-InfoSec/Sn1per
cd Sn1per
bash install.sh force
cd ~/tools

# Docker
echo -e "$OKGREEN[*] Installing Docker... $RESET"
cd ~
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
apt install -y docker-ce docker-ce-cli containerd.io

# Pull Docker images
echo -e "$OKGREEN[*] Pulling Docker Images... $RESET"
# Amass
docker pull caffix/amass

# Subfinder
docker pull projectdiscovery/subfinder:latest

# Notify
docker pull projectdiscovery/notify:latest

# ShuffleDNS
docker pull projectdiscovery/shuffledns:latest

# Sn1per
docker pull xer0dayz/sn1per

# Build Docker Images
echo -e "$OKGREEN[*] Building Docker Images... $RESET"
# Eyewitness
cd ~/tools/EyeWitness/Python
docker build --build-arg user=$USER --tag eyewitness --file ./Python/Dockerfile .
cd ~

# Joomscan
cd ~/tools/joomscan
docker build -t rezasp/joomscan .
cd ~

# Create dot files repo
# Move to relevant .config directory

apt clean
cd ~

echo -e "$OKGREEN"
echo -e "$OKGREEN   ______                          ____          _         __ "
echo -e "$OKGREEN  / ____/_____ ___   ___   ____   / __ \ ____   (_)____   / /_"
echo -e "$OKGREEN / / __ / ___// _ \ / _ \ / __ \ / /_/ // __ \ / // __ \ / __/"
echo -e "$OKGREEN/ /_/ // /   /  __//  __// / / // ____// /_/ // // / / // /_  "
echo -e "$OKGREEN\____//_/    \___/ \___//_/ /_//_/     \____//_//_/ /_/ \__/  "
echo -e "$OKGREEN"
echo -e "$OKGREEN"
echo -e "$RESET"
echo -e "$OKBLUE+ -- --=[ BB-Install by GreenPoint-InfoSec"
echo -e "$OKBLUE+ -- --=[ https://github.com/GreenPoint-InfoSec"
echo -e "$OKBLUE+ -- --=[ Usage ./install.sh [go archive file name e.g go1.17.5.linux-amd64.tar.gz]"
echo -e "$OKGREEN"
echo -e "$OKGREEN"
echo -e "$OKGREEN Thank you, your installations are now complete! Good luck and have fun!"
echo -e "$RESET"
