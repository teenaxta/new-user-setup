#!/bin/bash

# Function to create a new user
create_user() {
    read -p "Enter the new username: " newusername
    sudo adduser $newusername

    # Add the new user to the sudo group
    sudo usermod -aG sudo $newusername

    echo "User $newusername created and added to sudo group."
}

# Function to install zsh
install_zsh() {
    sudo apt update
    sudo apt install -y zsh
    echo "Zsh installed."
}

# Function to install oh my zsh
install_oh_my_zsh() {
    su - $newusername -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    echo "Oh My Zsh installed for $newusername."
}

# Function to install Miniconda
install_miniconda() {
    su - $newusername -c 'mkdir -p ~/miniconda3'
    su - $newusername -c 'wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh'
    su - $newusername -c 'bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3'
    su - $newusername -c 'rm -rf ~/miniconda3/miniconda.sh'
    su - $newusername -c '~/miniconda3/bin/conda init bash'
    su - $newusername -c '~/miniconda3/bin/conda init zsh'
    echo "Miniconda installed and initialized for $newusername."
}

# Function to clone zsh plugins
install_zsh_plugins() {
    su - $newusername -c 'git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting'
    su - $newusername -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
    echo "Zsh plugins installed for $newusername."
}

# Function to update .zshrc to include plugins
update_zshrc() {
    su - $newusername -c 'sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions fast-syntax-highlighting)/" ~/.zshrc'
    echo ".zshrc updated with new plugins for $newusername."
}

# Function to revoke sudo access
install_essentials() {
    sudo apt install -y nvtop
    sudo apt install -y snapd 
    sudo snap install -y teams-for-linux
    echo "Installed essentials."
}

# Function to revoke sudo access
revoke_sudo() {
    sudo deluser $newusername sudo
    echo "Sudo access revoked for $newusername."
}



# Main script execution
create_user
install_zsh
install_oh_my_zsh
install_miniconda
install_zsh_plugins
update_zshrc
install_essentials
# revoke_sudo

echo "Setup complete for user $newusername."
