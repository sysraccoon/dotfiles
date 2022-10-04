Basic installation:

```bash
cd
git clone https://github.com/sysraccoon/dotfiles.git
cd dotfiles/bootstrap
# install all community and core packages (aur install separately via yay)
sudo ./install-arch-packages packages/arch-normal-packages
# (optionally) install development specific packages
sudo ./install-arch-packages packages/arch-dev-packages
# configure links to configurations
./setup-config-links
```

Add ssh key to github and change https origin to ssh:

```bash
gh auth login
./upgrade-git-origin
```

Install yay and aur packages ([snippet source](https://github.com/Jguer/yay#source)):

```bash
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# install aur packages
./install-arch-packages packages/arch-aur-packages yay
```

Install blackarch and reverse packages([snippet source](https://blackarch.org/downloads.html)):

```bash
curl -O https://blackarch.org/strap.sh
echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -Syu

# install specific packages for reverse engineering
sudo ./install-arch-packages packages/arch-reverse-packages
```

Console layout setup ([snippet source](https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration)):

```bash
localectl set-keymap --no-convert dvorak
```

Set default applications (browser etc.):

```bash
./set-default-applications
```
