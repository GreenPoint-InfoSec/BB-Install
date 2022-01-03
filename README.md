# BB-Install

Set up VPS quickly with automation. My script will install most of the tools required for bug bounties.

Check for the latest version of [go](https://go.dev/doc/install). At the time of writing it was 1.17.5.

Run this one line, sit back and wait.

	apt update && apt upgrade -y && apt install -y git && cd ~ && git clone https://github.com/GreenPoint-InfoSec/BB-Install.git && cd BB-Install && ./install.sh go1.17.5.linux-amd64.tar.gz

Once Installation is complete run command:

	source .bashrc
