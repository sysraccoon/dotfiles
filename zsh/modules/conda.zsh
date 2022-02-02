if [ -f "$HOME/anaconda3/bin/conda" ]; then
	eval "$($HOME/anaconda3/bin/conda shell.zsh hook)"
else
	echo "$(basename $0): anaconda missed. Install it or disable module"
fi
