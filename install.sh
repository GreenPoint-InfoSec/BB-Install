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
sleep 1

if [ -z $1 ]; then
    echo -e "$OKRED Please specify the go file to download!"
    echo -e "$OKRED The latest version is go1.17.5.linux-amd64.tar.gz"
    echo -e "$OKRED Check https://go.dev/dl/ for the latest version!"
    echo -e "$RESET"
    exit 1
fi

cd ~

echo -e "$OKGREEN[*] Installing Dependencies... $RESET"
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
    iputils-ping \
    sudo
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
# go get github.com/incogbyte/shosubgo/apishodan
# go build main.go


mkdir tools && cd tools

# Clone my repos
echo -e "$OKGREEN[*] Cloning GreenPoint-InfoSec Repositories... $RESET"
git clone https://github.com/GreenPoint-InfoSec/Back-The-File-Up.git
git clone https://github.com/GreenPoint-InfoSec/Wordlists.git

# Eyewitness
echo -e "$OKGREEN[*] Cloning Eyewitness... $RESET"
git clone https://github.com/FortyNorthSecurity/EyeWitness.git

# Hunter.sh
echo -e "$OKGREEN[*] Cloning Hunter... $RESET"
git clone https://github.com/null-p4n/hunter.sh.git

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
# Amass
docker pull caffix/amass

# Subfinder
docker pull projectdiscovery/subfinder:latest

# Notify
docker pull projectdiscovery/notify:latest

# ShuffleDNS
docker pull projectdiscovery/shuffledns:latest


# Create dot files repo
# Move to relevant .config directory

source .bashrc

echo $GOPATH
echo $PATH
