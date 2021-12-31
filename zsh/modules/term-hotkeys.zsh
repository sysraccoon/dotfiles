bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line

bindkey '^k' up-history
bindkey '^[k' beginning-of-history
bindkey '^j' down-history
bindkey '^[j' end-of-history

bindkey '^l' forward-word
bindkey '^[l' forward-char
bindkey '^h' backward-word
bindkey '^[h' backward-char

bindkey '^r' history-incremental-search-backward

