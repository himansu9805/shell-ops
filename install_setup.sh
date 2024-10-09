#!bin/sh

# Function to check if package is installed
check_and_install() {
	if ! dpkg -s "$1" >/dev/null 2>&1; then
		echo "$1 is not installed. Installing..."
		sudo apt-get install -y $1
	else
		echo "$1 is already installed."
	fi
}

# Installing packages from package manager
PACKAGE_LIST="tmux python3 curl git gcc python3-pip"
sudo apt-get update
for package in $PACKAGE_LIST; do
	check_and_install $package
done	

# Installing packages by downloading the packages
# 1. Golang
if [ ! -d "/usr/local/go" ]; then
	echo "Golang is not installed. Installing..."
	wget https://dl.google.com/go/go1.23.2.linux-amd64.tar.gz
	sudo tar -C /usr/local -xvf go1.23.2.linux-amd64.tar.gz
	rm -rf go1.23.2.linux-amd64.tar.gz
	echo "export GOROOT=/usr/local/go " >> ~/.profile
	echo "export GOPATH=\$HOME/go" >> ~/.profile
	echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH" >> ~/.profile
	echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
else
	echo "Golang is already installed."
fi

# 2. Neo-Vim and AstroNvim
if [ ! -d "/opt/nvim-linux64" ]; then
	echo "Neovim is not installed. Installing..."
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
	echo "export PATH=\$PATH:/opt/nvim-linux64/bin" >> ~/.profile
	echo "Pulling AstroNvim configuration from GitHub..."
	git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
	rm -rf ~/.config/nvim/.git
else
	echo "Neovim is already installed."
fi

# Source the .profile for current shell
source ~/.profile 
