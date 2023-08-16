alias yay-i="yay -Slq | fzf --multi --exact --cycle --reverse --preview 'yay -Si {1}' | xargs -ro yay -S"
alias yay-up="yay -Syu"
