alias xxi='xbps-install -Sy'
alias xxq='xbps-query -Rs'
alias x='xbps-query -Rs "" | cut --delimiter " " --fields 1-2 | fzf --multi --exact --cycle --reverse --preview '"'xbps-query -R {2}'"' | cut --delimiter " " --fields 2 | xargs -ro sudo xbps-install'
