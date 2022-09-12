```bash
cd
git clone https://github.com/sysraccoon/dotfiles.git
cd dotfiles
# install all community and core packages (aur install separately via yay)
sudo ./packages/install-arch-packages.sh arch-normal-packages
# configure links to configurations
./setup
# configure gh connection
gh auth login
# now ssh connection available, you can change origin url
./upgrade-git-origin
```
