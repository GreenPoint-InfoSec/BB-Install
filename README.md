# BB-Install

Set up VPS quickly with automation. My script will install most of the tools required for bug bounties.

Check for the latest version of [go](https://go.dev/doc/install). The latest archive filename is required as the argument for install.sh. At the time of writing (1/1/22) it was 1.17.5 so go1.17.5.linux-amd64.tar.gz has been included.  

Run this one line, sit back and wait:

	sudo apt update && sudo apt upgrade -y && sudo apt install -y git && cd ~ && git clone https://github.com/GreenPoint-InfoSec/BB-Install.git && cd BB-Install && sudo ./install.sh go1.17.5.linux-amd64.tar.gz

Once Installation is complete run command:

	source .bashrc
