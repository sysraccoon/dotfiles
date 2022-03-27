# Dotfiles

## Installation Process

Nix package manager required. Several guides: 
[nixos wiki](https://nixos.wiki/wiki/Nix_Installation_Guide),
[arch wiki](https://wiki.archlinux.org/title/Nix)

If nix already installed and you can execute nix commands without root
type instructions presented below to shell.

```bash
cd
git clone git@github.com:sysraccoon/dotfiles.git
cd dotfiles
git fetch --all
git switch nixos
./bootstrap
```
