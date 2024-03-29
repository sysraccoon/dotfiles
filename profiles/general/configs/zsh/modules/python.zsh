# vim:fileencoding=utf-8:foldmethod=marker

alias gpip='PIP_REQUIRE_VIRTUALENV=false pip'
alias pva='source venv/bin/activate'

#{{{ pyenv

lazy_pyenv_aliases=("pyenv")

function load_pyenv {
    for lazy_pyenv_alias in $lazy_pyenv_aliases
    do
        unalias $lazy_pyenv_alias
    done

    export PYENV_ROOT="${HOME}/.pyenv"

    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

    unfunction load_pyenv
}

for lazy_pyenv_alias in $lazy_pyenv_aliases
do
    alias $lazy_pyenv_alias="load_pyenv && $lazy_pyenv_alias"
done

#}}}

#{{{ conda

lazy_conda_aliases=("conda")

function load_conda {
    for lazy_conda_alias in $lazy_conda_aliases
    do
        unalias $lazy_conda_alias
    done

    MINICONDA_PATH="$HOME/miniconda3/bin/conda"
    ANACONDA_PATH="$HOME/anaconda3/bin/conda"

    if [ -f "$MINICONDA_PATH" ]; then
      eval "$($MINICONDA_PATH shell.zsh hook)"
    elif [ -f "$ANACONDA_PATH" ]; then
      eval "$($ANACONDA_PATH shell.zsh hook)"
    elif [ "$DISABLE_CONDA_MESSAGE" -ne 1 ]; then
      echo "$(basename $0): anaconda/miniconda missed. Install it or set env var DISABLE_CONDA_MESSAGE to 1"
    fi

    unfunction load_conda
}

for lazy_conda_alias in $lazy_conda_aliases
do
    alias $lazy_conda_alias="load_conda && $lazy_conda_alias"
done

#}}}
