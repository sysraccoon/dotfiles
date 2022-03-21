bindkey -e

bindkey '^f' forward-word
bindkey '^[f' forward-char
bindkey '^b' backward-word
bindkey '^[b' backward-char

function yank-current-buffer {
    echo "$BUFFER" | cb-set
}
zle -N yank-current-buffer
bindkey "\ey" yank-current-buffer

