# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#     exec tmux new -s "tmp-term-$(date +%s%N)" && exit;
# fi
#
# alias tmux-kill-temp="tmux list-sessions -F '#{session_attached} #{session_id} #{session_name}' | grep 'tmp-term-' | awk '/^0/{print \$2}' | xargs -n 1 tmux kill-session -t "

alias tmux-up="tmux source $XDG_CONFIG_HOME/tmux/tmux.conf"

