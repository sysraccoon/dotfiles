# pyenv support
export PYENV_ROOT="${HOME}/.pyenv"

if [ -d "${PYENV_ROOT}" ]; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

MINICONDA_PATH="$HOME/miniconda3/bin/conda"
ANACONDA_PATH="$HOME/anaconda3/bin/conda"

if [ -f "$MINICONDA_PATH" ]; then
  eval "$($MINICONDA_PATH shell.zsh hook)"
elif [ -f "$ANACONDA_PATH" ]; then
  eval "$($ANACONDA_PATH shell.zsh hook)"
elif [ "$DISABLE_CONDA_MESSAGE" -ne 1 ]; then
  echo "$(basename $0): anaconda/miniconda missed. Install it or set env var DISABLE_CONDA_MESSAGE to 1"
fi

