# Dotfiles

## Installation Process

Nix package manager required. Several guides: 
[nixos wiki](https://nixos.wiki/wiki/Nix_Installation_Guide),
[arch wiki](https://wiki.archlinux.org/title/Nix)

If nix already installed and you can execute nix commands without root
type instructions presented below to shell.

```sh
cd
git clone git@github.com:sysraccoon/dotfiles.git
cd dotfiles
git fetch --all
git switch nixos
./bootstrap
```

NixOS specific:

```sh
# For security reasons, change system folder owner to root
sudo chown root:root system
# Link system folder
sudo ln -s $(pwd)/system/nixos /etc/nixos
sudo nixos-rebuild switch
```

