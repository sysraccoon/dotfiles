# Pacman Mirrors

Install reflector:

```bash
sudo pacman -S reflector
```

Display 5 most recent updated mirrors from BY and RU regions:

```bash
reflector --country by,ru --latest 5 --protocol https --sort age
```

Save them to config:

```bash
reflector --country by,ru --latest 5 --protocol https --sort age --save /etc/pacman.d/mirrorlist
```

Enable automatic mirror updates:

```bash
# configure reflector service config
sudo vim /etc/xdg/reflector/reflector.conf
# start service
sudo systemctl enable reflector.service
sudo systemctl start reflector.service
```

