## General

## Setup

```sh
# clone repository
git clone git@github.com:sysraccoon/dotfiles.git ~/dotfiles
# add symlinks
sudo ln -sT ~/dotfiles /etc/nixos # nixos system configuration
ln -sT ~/dotfiles/ ~/.config/home-manager/ # home-manager configuration
# apply configurations
sudo nixos-rebuild switch
home-manager switch
```