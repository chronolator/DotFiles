#!/bin/bash

# Includes
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/include.sh"

# Options
CONFIG="./.config"
HOME_CONFIG="$HOME/.config"
ZSH="zsh"
TMUX="tmux"
NVIM="nvim"
DISTRO=$(cat /etc/os-release | grep -io "^id=.*" | awk -F'=' '{print $2}' | sed 's/\"//g')
RHEL=("centos" "rhel" "fedora" "rocky")
DEB=("ubuntu" "debian" "linuxmint" "kali")

# Ensure that arguments are specified
if [[ -z "$1" ]]; then
    echo -e "$be${c[11]}Part 1 is for installing zsh, tmux, and LunarVim dotfiles, and Part 2 is for after LunarVim has installed its plugins."
    echo -e "$be${c[10]}$0$ee $be${c[9]} <Part 1|2>$ee"
    echo -e "Example: $0 1"
    exit
fi
echo ""

# If PART 1, then install zsh, tmux, and LunarVim, if PART 2, then edit LunarVim plugins
if [[ "$PART" == 1 ]]; then
    # Ensure that dependencies are installed
    info 0 "Guessing OS distro and installing dependencies"
    echo ""
    if [[ $DISTRO == ${DEB[0]} ]] || [[ $DISTRO == ${DEB[1]} ]] || [[ $DISTRO == ${DEB[2]} ]] || [[ $DISTRO == ${DEB[3]} ]]; then
        allcheck 0 "Attempting to install dependencies" apt install nvim xsel zsh tmux exa fzf -y
    elif [[ $DISTRO == ${RHEL[0]} ]] || [[ $DISTRO == ${RHEL[1]} ]] || [[ $DISTRO == ${RHEL[2]} ]] || [[ $DISTRO == ${RHEL[3]} ]]; then
        allcheck 0 "Attempting to install dependencies" yum install nvim xsel zsh tmux exa fzf -y
    else
        info 1 "Unable to guess the OS distro"
        echo ""
        exit
    fi

    # Create .config if it does not already exist
    allcheck 0 "Creating ~/.config/ folder" mkdir -p ~/.config/

    # Install zsh dotfiles
    allcheck 0 "" cp -pvf $CONFIG/
    
    # Install tmux dotfiles
    
    # Install LunarVim
    # https://github.com/LunarVim/Neovim-from-scratch
    git clone https://github.com/LunarVim/Neovim-from-scratch.git ~/.config/nvim
    
    
    # Replace LunarVim with nvim dotfiles
    
    
    # Launch nvim and wait for plugins to be installed
    
    
    # Edit nvim theme
    
    ln -s $HOME/.config/zsh/.zshrc $HOME/.zshrc
    mkdir -p $HOME/.config/zsh/plugins/zsh-antigen/ && curl -L git.io/antigen > $HOME/.config/zsh/plugins/antigen/antigen.zsh
