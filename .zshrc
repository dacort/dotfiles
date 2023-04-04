(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add the hook for direnv, along with the initialization above
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"


# Set Spaceship ZSH as a prompt
#autoload -U promptinit; promptinit
#prompt spaceship

# Local tools (like poetry)
export PATH="$HOME/.local/bin:$PATH"

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

# -X - Don't clear on pager quit
# -F - Quit immmediately if we can
# -R - Show terminal colors
export LESS="-XFR"

# Sometimes we like color in our pager
jql() { jq -C "$@" | less }

# -F - Show trailing slashes
# -G - Enable color by default
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
#envSource ~/.zsh/sekrets.env
#safeSource ~/.zsh/dotenv.plugin.zsh

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

# Better tool management
. /usr/local/opt/asdf/libexec/asdf.sh

# flutter
export PATH="$PATH:$HOME/Downloads/flutter/bin"


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
safeSource '$HOME/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
safeSource '$HOME/google-cloud-sdk/completion.zsh.inc'
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# Created by `pipx` on 2021-08-02 19:01:02
export PATH="$PATH:$HOME/.local/bin"

# Don't take 20 minutes to install a single package
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=true

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
