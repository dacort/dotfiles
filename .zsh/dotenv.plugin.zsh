## Settings

# Filename of the dotenv file to look for
: ${ZSH_DOTENV_FILE:=.env}


## Functions

source_env() {
  if [[ -f .env ]]; then
    # test .env syntax
    zsh -fn .env || echo 'dotenv: error when sourcing `.env` file' >&2

    echo -n "dotenv: found '$ZSH_DOTENV_FILE' file. Source it? ([Y]es/[n]o) "
    read -k 1 confirmation; [[ "$confirmation" != $'\n' ]] && echo
    
    # check input
    case "$confirmation" in
      [nN]) return ;;
      *) ;; # interpret anything else as a yes
    esac

    setopt localoptions allexport
    source $ZSH_DOTENV_FILE
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env

source_env
