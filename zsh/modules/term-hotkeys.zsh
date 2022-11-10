bindkey -e

bindkey '^f' forward-word
bindkey '^[f' forward-char
bindkey '^b' backward-word
bindkey '^[b' backward-char

function __yank-current-buffer {
    echo "$BUFFER" | cb-set
}
zle -N __yank-current-buffer
bindkey "\ey" __yank-current-buffer

function __show-command-source {
    bat --paging always --pager "less -Rc" =$(echo "$BUFFER" | awk '{print $1;}')
}
zle -N __show-command-source
bindkey "\es" __show-command-source

