alias pac-i="pacman -Slq | fzf --multi --exact --cycle --reverse --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias pac-up="pacman -Syu"
alias pac-r="pacman -Rns"
alias pac-cc="paccache -rk1"

