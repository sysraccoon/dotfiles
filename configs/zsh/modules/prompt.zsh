# HELPER FUNCTIONS

function venv_name {
    [ $VIRTUAL_ENV ] && basename "$VIRTUAL_ENV"
}

function prompt_part {
    prompt=$1
    color_index=${2:-6}

    COLOR='\033[38;5;'$color_index'm'
    RESET='\033[0m'
    [ $prompt ] && echo -ne "─$COLOR⌠ "$prompt" ⌡$RESET"
}

function dyn_prompt_part {
    dyn_prompt=$1
    color_index=${2:-6}
    echo '$(prompt_part "'$dyn_prompt'" '$color_index')'
}

# disable default python venv prompt
export VIRTUAL_ENV_DISABLE_PROMPT=0

# PROMPT CONFIG

# expand inner functions
setopt PROMPT_SUBST
#$(dyn_prompt_part '$(git rev-parse --show-toplevel &2>/dev/null | xargs basename)')
export PROMPT="
%{$reset_color%}╭$(prompt_part '%~')$(dyn_prompt_part '$(venv_name)' '3')$(dyn_prompt_part '$(git-project-name)' '1')$(dyn_prompt_part '$ANDROID_SERIAL' '2')
%{$reset_color%}╰─%# "
