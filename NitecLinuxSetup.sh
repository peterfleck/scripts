#! /bin/bash

# INSTALL SOME DEFAULT REQUIREMENTS

sudo apt-get update && sudo apt-get upgrade
sudo apt-get --yes install build-essential apt-transport-https ca-certificates wget curl unzip software-properties-common filezilla gpg git gitk git-gui git-flow ripgrep fzf fd-find vinagre xclip xz-utils vim vanilla-gnome-desktop ttf-mscorefonts-installer ubuntu-restricted-extras gnome-tweaks synaptic

# SETUP SSH KEY

echo "y\n" | HOSTNAME=`hostname` ssh-keygen -t rsa -C "$HOSTNAME" -f "$HOME/.ssh/id_rsa" -P ""

# SETUP GIT

git config --global user.email ""
git config --global user.name ""
git config --global core.editor "vim"
git config --global init.defaultBranch master
git config --global fetch.prune true
git config --global pull.rebase false

#### SETUP VARIOUS MICROSOFT SOFTWARE ####

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
rm -f packages.microsoft.gpg

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Get Ubuntu version
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)

# Download Microsoft signing key and repository
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# Install Microsoft signing key and repository
sudo dpkg -i packages-microsoft-prod.deb

# Clean up
rm packages-microsoft-prod.deb

# Update packages
sudo apt-get update

# INSTALL DOTNET

sudo apt-get --yes install dotnet-sdk-8.0

# INSTALL INTUNE
sudo apt-get --yes install intune-portal

# INSTALL MICROSOFT EDGE
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo apt-get update && sudo apt-get --yes install microsoft-edge-stable


# INSTALL VS CODE
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update && sudo apt-get --yes install code

code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension ms-dotnettools.csharp
code --install-extension ms-dotnettools.csdevkit
code --install-extension ms-dotnettools.dotnet-maui
code --install-extension mongodb.mongodb-vscode
code --install-extension redhat.vscode-xml
code --install-extension redhat.vscode-yaml

# INSTALL AZURE DATA STUDIO

sudo apt-get --yes install libxss1 libgconf-2-4 libunwind8
wget https://azuredatastudio-update.azurewebsites.net/latest/linux-deb-x64/stable -O ~/Downloads/azuredatastudio.deb
sudo dpkg -i ~/Downloads/azuredatastudio.deb

# INSTALL AZURE STORAGE EXPLORER

# https://go.microsoft.com/fwlink/?linkid=2216383&clcid=0x409

# INSTALL NODEJS LTS

sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=22
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update && sudo apt-get install nodejs -y

# INSTALL MONGO COMPASS

wget https://downloads.mongodb.com/compass/mongodb-compass_1.43.5_amd64.deb -O ~/Downloads/mongocompass.deb
sudo dpkg -i ~/Downloads/mongocompass.deb

# INSTALL 1Password

curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo apt update && sudo apt install --yes 1password

# INSTALL NEOVIM

sudo apt-get --yes install ninja-build gettext cmake
cd ~/Downloads
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
sudo make install
cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb

# git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
# cd ~/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -O ~/Downloads/JetBrainsMono.tar.xz
cd ~/Downloads
sudo tar -xvf JetBrainsMono.tar.xz
sudo cp -r *.ttf /usr/local/share/fonts
sudo fc-cache -f -v
cd ~/Downloads
sudo rm -R *.ttf

# DOWNLOAD DEVOPS REPOS HAS TO BE DONE IN SEPARATE SCRIPT AS NEED TO LOGIN TO COMPLIANT DEVICE
