# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

## ZSH SPECIFIC ## 

# Easily cd into src directories
setopt auto_cd
cdpath=($HOME/src $HOME/mbsrc)

# Ask to autocorrect my typos
setopt CORRECT
setopt CORRECT_ALL

# Command completion
autoload -Uz compinit && compinit


## ZSH PLUGINS

# Help my bad memory
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Lend me a hand as I type
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


## COMMANDS ##

# Don't clear on pager quit
# Quit immmediately if we can
# Show terminal colors
export LESS="-XFR"

# Show trailing slashes
# Enable color by default
alias ls="ls -FG"

# Make the ls colors a little better
export LSCOLORS="Gxfxcxdxbxegedabagacab"


## HELPER FUNCTIONS ##
function listTags() {
    local repo=${1}
    local size=${2:-25}
    local page=${3:-1}
    [ -z "${repo}" ] && echo "Usage: listTags <repoName> [size] [pageIndex]" 1>&2 && return 1
    curl "https://hub.docker.com/v2/repositories/${repo}/tags?page=${page}&page_size=${size}" 2>/dev/null | jq -r '.results[].name' | sort
}


## GIT SHORTCUTS ##

alias gs='git status -sb -uno'
alias gd='git diff'
alias gp='git push origin HEAD'
alias gpu='git push -u'


## DEV ENVIRONMENTS ##

# nodenv init
if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi

# rbenv init
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# flutter
export PATH="$PATH:$HOME/Downloads/flutter/bin"


## ALIASES ##

alias config='/usr/bin/git --git-dir='${HOME}'/.cfg/ --work-tree='${HOME}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dacort/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dacort/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dacort/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dacort/google-cloud-sdk/completion.zsh.inc'; fi