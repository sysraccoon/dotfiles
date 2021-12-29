installation process

```bash
sudo xbps-install -S $(cat void-packages | grep -v '!!')
ln -s "$(pwd)/zsh/machine/config-name" $HOME/.zshrc
ln -s "$(pwd)/bin" $HOME/bin
```
