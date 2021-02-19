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


## COMMANDS ##

# Don't clear on pager quit
# Quit immmediately if we can
# Show terminal colors
export LESS="-XFR"

# Sometimes we like color in our pager
jql() { jq -C "$@" | less }

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

# Only sources the file if it exists
function safeSource() {
    if [ -f "${1}" ]; then . "${1}"; fi
}

# Export env files
function envSource() {
    set -a
    . "$1"
    set +a
}


## Additional source files
envSource ~/.zsh/sekrets.env


## ZSH PLUGINS

# Help my bad memory
safeSource /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Lend me a hand as I type
safeSource /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


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

# Add getopt path - was for building Airflow with breeze
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

# go binaries
export PATH=$PATH:$HOME/go/bin


## ALIASES ##

alias config='/usr/bin/git --git-dir='${HOME}'/.cfg/ --work-tree='${HOME}

# My muscle memory does not appreciate _not_ typing git
# Thank you https://gpanders.com/blog/managing-dotfiles-with-git/
git() {
	if [ "$PWD" = "$HOME" ]; then
		command git --git-dir="$HOME/.cfg" --work-tree="$HOME" "$@"
	else
		command git "$@"
	fi
}

# Filter out unnecessary data from aws commands
jaws() { aws "$@" | jq 'del(.virtualClusters[] | .arn, .tags)' }
# I tried several other variations including the basic compdef jaws=aws
# but none of them worked unless I typed it in the terminal. So...
# (shrug) https://stackoverflow.com/a/4221640
compdef '_dispatch aws aws' jaws

# The next line updates PATH for the Google Cloud SDK.
safeSource '/Users/dacort/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
safeSource '/Users/dacort/google-cloud-sdk/completion.zsh.inc'
