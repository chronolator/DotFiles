#!/bin/bash

# Includes
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/include.sh"

# Options
CONFIG="./.config"
CUSER="$1"
CID="$(getent passwd $CUSER | cut -d: -f3)"
HOME_USER="$(getent passwd $SUDO_USER | cut -d: -f6)"
HOME_CONFIG="$HOME_USER/.config"
ZSH="zsh"
TMUX="tmux"
NVIM="lvim"
DISTRO=$(cat /etc/os-release | grep -io "^id=.*" | awk -F'=' '{print $2}' | sed 's/\"//g')
RHEL=("centos" "rhel" "fedora" "rocky")
RHEL_PKGS="neovim xsel zsh tmux exa fzf"
DEB=("ubuntu" "debian" "linuxmint" "kali")
DEB_PKGS="neovim xsel zsh tmux exa fzf"

# Ensure user is running as root
rootcheck

# Ensure that arguments are specified
if [[ -z "$1" ]]; then
    echo -e "$be${c[10]}$0$ee $be${c[9]} <USER>$ee"
    echo -e "Example: $0 root"
    echo -e "Example: $0 bob"
    exit
fi

# Check if user does not exist
if ! id "$CUSER" &> /dev/null; then
    echo -e "$be${c[9]}User does not exist$ee"
    exit
fi

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

# If user exists and is not root
if id "$CUSER" &> /dev/null && [[ "$CID" -ne 0 ]]; then
    # Create .config if it does not already exist
    allcheck 0 "Creating ~/.config/ folder" mkdir -pv $HOME_CONFIG/

    # Install zsh dotfiles
    allcheck 0 "Installing zsh dotfiles" cp -pvrf $CONFIG/$ZSH $HOME_CONFIG/
    allcheck 0 "Removing zsh-prompt-root for a normal one" rm -fv $HOME_CONFIG/$ZSH/.zsh-prompt-root
    allcheck 0 "Creating .zshrc symlink" ln -svf $HOME_CONFIG/$ZSH/.zshrc $HOME_USER/.zshrc

    # Install tmux dotfiles
    allcheck 0 "Installing tmux dotfiles" cp -pvrf $CONFIG/$TMUX $HOME_CONFIG/
    allcheck 0 "Creating .tmux.conf symlink" ln -svf $HOME_CONFIG/$TMUX/.tmux.conf $HOME_USER/.tmux.conf

    # Install LunarVim
    # https://github.com/LunarVim/Neovim-from-scratch
    #git clone https://github.com/LunarVim/Neovim-from-scratch.git $HOME_CONFIG/$NVIM
    info 0 "Installing LunarVim"
    #su $SUDO_USER -c "LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)"
    su $SUDO_USER -c "LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)"
    ifcheck "installing LunarVim"

    # Set ownwership to the user
    allcheck 0 "Changing ownwership for $HOME_CONFIG/$ZSH" chown -Rv $SUDO_USER:$SUDO_USER $HOME_CONFIG/$ZSH
    allcheck 0 "Changing ownwership for $HOME_CONFIG/$TMUX" chown -Rv $SUDO_USER:$SUDO_USER $HOME_CONFIG/$TMUX
    allcheck 0 "Changing ownwership for $HOME_CONFIG/$NVIM" chown -Rv $SUDO_USER:$SUDO_USER $HOME_CONFIG/$NVIM

# If user exists and is root/has an id of 0 (Yes, I know copying code is bad practice, whatever I will fix this later)
elif id "$CUSER" &> /dev/null && [[ "$CID" -eq 0 ]]; then
    # Set HOME_USER to the root user
    HOME_USER=$(getent passwd $USER | cut -d: -f6)
    HOME_CONFIG="$HOME_USER/.config"

    # Create .config if it does not already exist
    allcheck 0 "Creating ~/.config/ folder" mkdir -pv $HOME_CONFIG/

    # Install zsh dotfiles
    allcheck 0 "Installing zsh dotfiles" cp -pvrf $CONFIG/$ZSH $HOME_CONFIG/
    allcheck 0 "Installing zsh root prompt" mv -vf $HOME_CONFIG/$ZSH/zsh-prompt-root $HOME_CONFIG/$ZSH/zsh-prompt
    allcheck 0 "Creating .zshrc symlink" ln -svf $HOME_CONFIG/$ZSH/.zshrc $HOME_USER/.zshrc

    # Install tmux dotfiles
    allcheck 0 "Installing tmux dotfiles" cp -pvrf $CONFIG/$TMUX $HOME_CONFIG/
    allcheck 0 "Creating .tmux.conf symlink" ln -svf $HOME_CONFIG/$TMUX/.tmux.conf $HOME_USER/.tmux.conf

    # Install LunarVim
    # https://github.com/LunarVim/Neovim-from-scratch
    #git clone https://github.com/LunarVim/Neovim-from-scratch.git $HOME_CONFIG/$NVIM
    info 0 "Installing LunarVim"
    #LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
    LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)
    ifcheck "installing LunarVim"

    # Set ownwership to the user
    allcheck 0 "Changing ownwership for $HOME_CONFIG/$ZSH" chown -Rv $USER:$USER $HOME_CONFIG/$ZSH
    allcheck 0 "Changing ownwership for $HOME_CONFIG/$TMUX" chown -Rv $USER:$USER $HOME_CONFIG/$TMUX
    allcheck 0 "Changing ownwership for $HOME_CONFIG/$NVIM" chown -Rv $USER:$USER $HOME_CONFIG/$NVIM
fi

# Change default login shell for user
ZSH_PATH="$(which zsh)"
allcheck 0 "Changing the default login shell to zsh" sed -ri "\%$CUSER%s%:/bin.*|:/usr/bin.*%:${ZSH_PATH}%g" /etc/passwd

# Edit nvim theme
allcheck 0 "Modifying the default neovim theme to be transparent" sed -i 's/transparent\ =\ false/transparent\ =\ true/g' "$HOME_USER/.local/share/lunarvim/site/pack/packer/start/tokyonight.nvim/lua/tokyonight/config.lua"
allcheck 0 "Modifying the default neovim colorscheme to be tokyonight" sed -i 's/lvim.colorscheme\ =\ "lunar"/lvim.colorscheme\ =\ "tokyonight"/g' "$HOME_CONFIG/$NVIM/config.lua"

# Launch nvim and wait for plugins to be installed
echo -e "$be${c[13]}Now manually launch lvim and wait for the plugins to finish installing, which can be seen at the bottom status bar$ee"
