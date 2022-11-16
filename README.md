# DotFiles
My lightweight dotfiles, which include zsh, tmux, and neovim.
![](https://github.com/chronolator/DotFiles/blob/master/images/lvim.png)  

## Dependencies
The install script will attempt to guess your Linux distribution based on Ubuntu, Debian, Linuxmint, Kali, CentOS, RHEL, Fedora, and Rocky to install the dependencies.  
If you want to install the dependencies on your own, you can simply comment out lines 41-51:  
```
#info 0 "Guessing OS distro and installing dependencies"
#echo ""
#if [[ $DISTRO == ${DEB[0]} ]] || [[ $DISTRO == ${DEB[1]} ]] || [[ $DISTRO == ${DEB[2]} ]] || [[ $DISTRO == ${DEB[3]} ]]; then
#    allcheck 0 "Attempting to install dependencies" apt install nvim xsel zsh tmux exa fzf -y
#elif [[ $DISTRO == ${RHEL[0]} ]] || [[ $DISTRO == ${RHEL[1]} ]] || [[ $DISTRO == ${RHEL[2]} ]] || [[ $DISTRO == ${RHEL[3]} ]]; then
#    allcheck 0 "Attempting to install dependencies" yum install nvim xsel zsh tmux exa fzf -y
#else
#    info 1 "Unable to guess the OS distro"
#    echo ""
#    exit
#fi
```

Be aware that this installation has only been tested on Fedora.  
These are the dependency versions that were used for testing:  
```
zsh 5.8.1  
tmux 3.3a  
neovim 0.8.0  
fzf 0.33.0  
xsel 1.2.0  
exa 0.10.1  
```

If you already have the dependencies installed, you can check the versions in case any errors occur:  
```
zsh --version
tmux -v
nvim -v | head -n1
fzf --version
xsel --version
exa --version | grep -Pi '^v.*'
```  

## Install
Clone the repository:  
```
git clone https://github.com/chronolator/DotFiles.git
```  

Enter the folder:  
```
cd DotFiles
```  

Run script with the user that you want to install under:  
```
sudo ./install.sh <USER>
```  

Run lvim as the user that it was installed under and wait until all the LunarVim plugins are installed, which can be seen on the bottom status bar:  
```
lvim
```  

Exit out of lvim and start a new zsh instance to finish:  
```
zsh
```  
