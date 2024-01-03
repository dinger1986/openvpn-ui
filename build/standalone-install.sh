#!/bin/bash
# VERSION 0.1 by d3vilh@github.com aka Mr. Philipp.
#
#  DRAFT! DO NOT USE IT!
#

*******
sudo mkdir /opt/openvpn-ui
cd /opt/openvpn-ui/

sudo apt install openvpn easy-rsa -y

wget https://github.com/d3vilh/openvpn-ui/archive/refs/tags/0.9.4.1.tar.gz

tar -xf 0.9.4.1.tar.gz

cd openvpn-ui-0.9.4.1/

echo -e "PATH=\$PATH:/usr/local/go/bin" | sudo tee /etc/profile.d/golang.sh >/dev/null

cd /tmp
wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz

sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz

rm -f go1.21.4.linux-amd64.tar.gz

source /etc/profile.d/golang.sh

go get github.com/beego/beego/v2@latest


sh-Test:/opt/openvpn-ui/openvpn-ui-0.9.4.1# export HOME=/root
root@GoPhish-Test:/opt/openvpn-ui/openvpn-ui-0.9.4.1# echo $HOME
/root
root@GoPhish-Test:/opt/openvpn-ui/openvpn-ui-0.9.4.1# mkdir -p $HOME/.config


go env -w GOFLAGS="-buildvcs=false" && bee version && CGO_ENABLED=1 CC=musl-gcc bee pack -exr='^vendor|^ace.tar.bz2|^data.db|^build|^README.md|^docs' && cd /app/qrencode && go build -o qrencode main.go && chmod +x /app/qrencode/qrencode && cp -p /app/qrencode/qrencode /go/src/github.com/d3vilh/openvpn-ui/
*******


# All the variables
QRFILE="qrencode"
UIFILE="openvpn-ui.tar.gz"

# Check if Go is installed and the version is 1.21
go_version=$(go version | awk '{print $3}' | tr -d "go")
if [[ -z "$go_version" || "$go_version" < "1.21" ]]
then
    echo "Golang is not installed or the version is less than 1.21!"
    exit 1
fi

# How to install Golang 1.21 on x86 linux:
# wget https://golang.org/dl/go1.21.5.linux-amd64.tar.gz
# sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
# export PATH=$PATH:/usr/local/go/bin
# echo "export PATH=$PATH:$(go env GOPATH)/bin" >> ~/.bashrc
# source ~/.bashrc

# Description
echo "This script will install OpenVPN-UI and all the dependencies on your local environment. No containers will be used."
echo "THIS SCRIPT IS IN DEVELOPMENT AND NOT READY FOR ANY USE."
# Ask for confirmation
read -p "Do you want to continue? (y/n)" -n 1 -r
echo    # move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Update your system
echo "Updating current enviroment with apt-get update"
sudo apt-get update -y

# Install necessary tools
echo "Installing dependencies (go bee sed gcc)"
sudo apt-get install -y sed gcc git musl-tools easy-rsa curl jq oathtool

echo "Downloading all go modules (go mod download)"
go mod download

echo "Installing BeeGo v2"
go install github.com/beego/bee/v2@develop
source ~/.bashrc # reload bashrc to get bee command
echo "Cloning qrencode into build directory"
git clone https://github.com/d3vilh/qrencode

# Set environment variables
export GO111MODULE='auto'
export CGO_ENABLED=1
export CC=musl-gcc 

# Change project directory
cd ../

# Execute bee pack
go env -w GOFLAGS="-buildvcs=false"
bee version
bee pack -exr='^vendor|^ace.tar.bz2|^data.db|^build|^README.md|^docs'

# Build qrencode
echo "Building qrencode"
cd build/qrencode
go build -o qrencode main.go
chmod +x qrencode
echo "Moving qrencode to GOPATH"
mv qrencode $(go env GOPATH)/bin
cd ../

printf "\033[1;34mAll done.\033[0m\n"
