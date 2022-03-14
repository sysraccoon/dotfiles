function yank-current-buffer {
    echo "$BUFFER" | cb-set
}
zle -N yank-current-buffer
bindkey "\ey" yank-current-buffer

