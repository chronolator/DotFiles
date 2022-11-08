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
RHEL_PKGS="neovim xsel zsh tmux exa fzf"
DEB=("ubuntu" "debian" "linuxmint" "kali")
DEB_PKGS="neovim xsel zsh tmux exa fzf"

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
        allcheck 0 "Attempting to install dependencies" apt install $DEB_PKGS -y
    elif [[ $DISTRO == ${RHEL[0]} ]] || [[ $DISTRO == ${RHEL[1]} ]] || [[ $DISTRO == ${RHEL[2]} ]] || [[ $DISTRO == ${RHEL[3]} ]]; then
        allcheck 0 "Attempting to install dependencies" yum install $RHEL_PKGS -y
    else
        info 1 "Unable to guess the OS distro"
        echo ""
        exit
    fi

    # Create .config if it does not already exist
    allcheck 0 "Creating ~/.config/ folder" mkdir -p $HOME_CONFIG/

    # Install zsh dotfiles
    allcheck 0 "Installing zsh dotfiles" cp -pvf $CONFIG/$ZSH $HOME_CONFIG/
    allcheck 0 "Creating .zshrc symlink" ln -sv $HOME_CONFIG/$ZSH/.zshrc $HOME/.zshrc
    
    # Install tmux dotfiles
    allcheck 0 "Installing tmux dotfiles" cp -pvf $CONFIG/$TMUX $HOME_CONFIG/
    allcheck 0 "Creating .tmux.conf symlink" ln -sv $HOME_CONFIG/$TMUX/.tmux.conf $HOME/.tmux.conf
    
    # Install LunarVim
    # https://github.com/LunarVim/Neovim-from-scratch
    git clone https://github.com/LunarVim/Neovim-from-scratch.git ~/.config/nvim
    
    # Replace LunarVim with neovim dotfiles
    allcheck 0 "Installing nvim dotfiles" cp -pvf $CONFIG/$NVIM $HOME_CONFIG/

    # Launch nvim and wait for plugins to be installed
    echo -e "$be${c[13]}Now manually launch nvim and wait for the plugins to finish installing, which can be seen at the bottom status bar$ee"
fi

# PART 2
if [[ "$PART" == 2 ]]; then
    # Edit nvim theme
    allcheck 0 "Modifying the default neovim theme to be transparent" sed -i 's/transparent\ =\ true/transparent\ =\ false/g' $HOME/.local/share/nvim/site/pack/packer/start/tokyonight.nvim/lua/tokyonight/config.lua
fi

