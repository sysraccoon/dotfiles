if [[ $SCREENCAST_MODE == "1" ]]; then
    # override starship prompt
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/screencast.toml"
fi

