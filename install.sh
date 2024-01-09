#!/bin/bash

# define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ESSENTIAL_PACKAGES="build-essential tmux git vim curl wget zsh gdb gdb-multiarch python3 python3-pip python3-dev net-tools openssh-server"

print_message() {
    local indent=$1
    local type=$2
    local message=$3
    local spaces=$(printf '%*s' $indent)
    case $type in
        "info")
            echo -e "${spaces}${YELLOW}[*] ${message}${NC}"
            ;;
        "success")
            echo -e "${spaces}${GREEN}[+] ${message}${NC}"
            ;;
        "error")
            echo -e "${spaces}${RED}[!] ${message}${NC}"
            ;;
        *)
            echo -e "${spaces}${message}"
            ;;
    esac
}

# check sudo permission
if [ "$EUID" -ne 0 ]
  then print_message 0 "error" "Please run as root"
  exit
fi

# update source list and install essential packages
print_message 0 "info" "Updating source list and installing essential packages"
apt-get update -y
apt-get install -y ${ESSENTIAL_PACKAGES}

# install and config oh-my-zsh
print_message 0 "info" "Installing oh-my-zsh"
echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/' $HOME/.zshrc
sed -i '/^PROMPT=/{N;s/\n//}' $HOME/.oh-my-zsh/themes/ys.zsh-theme
source $HOME/.zshrc

# install and config vim 
print_message 0 "info" "Installing vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp $(pwd)/.vimrc $HOME/.vimrc
mkdir -p $HOME/.vim/colors
cp $HOME/.vim/plugged/vim-colors-solarized/colors/solarized.vim $HOME/.vim/colors/
vim +PlugInstall +qall
$HOME/vim/plugged/YouCompleteMe/install.sh

# install and config tmux
print_message 0 "info" "Installing tmux"
git clone https://github.com/gpakosz/.tmux.git $HOME/.tmux
ln -s -f $HOME/.tmux/.tmux.conf
cp $HOME/.tmux/.tmux.conf.local .
sed -i '/set -g prefix2 C-a/s/^/#/' $HOME/.tmux/.tmux.conf
sed -i '/bind C-a send-prefix -2/s/^/#/' $HOME/.tmux/.tmux.conf

# install and config gdb
print_message 0 "info" "Installing gdb"
git clone https://github.com/pwndbg/pwndbg.git $HOME/.pwndbg
git clone https://github.com/jerdna-regeiz/splitmind.git $HOME/.splitmind
cp $(pwd)/.gdbinit $HOME/.gdbinit