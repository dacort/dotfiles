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
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  BREW_PATH="$(brew --prefix)"
fi
autoload -Uz compinit && compinit

# I am k8s now
if type kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

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
safeSource ${BREW_PATH}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Lend me a hand as I type
safeSource ${BREW_PATH}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


## GIT SHORTCUTS ##
alias gs='git status -sb -uno'
alias gd='git diff'
alias gp='git push origin HEAD'
alias gpu='git push -u'
alias grm='git branch --merged | command grep -Ev "(^\*|^\+|master|main|dev)" | xargs --no-run-if-empty git branch -d'


## DEV ENVIRONMENTS ##

# Better tool management
safeSource ${BREW_PATH}/opt/asdf/libexec/asdf.sh

# flutter
export PATH="$PATH:$HOME/Downloads/flutter/bin"

# Oh no, more tool management
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# env env env env
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# JAVA env java env Java
alias j17="export JAVA_HOME=`/usr/libexec/java_home -v 17`; java -version"
alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"
alias j21="export JAVA_HOME=`/usr/libexec/java_home -v 21`; java -version"



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

# When I run grep is VS Code, I want to output line numbers
# but _only if_ I'm not grepping stdin
grep() {
#	if [ "$TERM_PROGRAM" = "vscode" -a [ -t 0 ] ]; then
	if [ "$TERM_PROGRAM" = "vscode" ]; then
		command grep -n "$@"
	else
		command grep "$@"
	fi
}

# Filter out unnecessary data from aws commands
jaws() { aws "$@" | jq 'del(.virtualClusters[] | .arn, .tags)' }
# I tried several other variations including the basic compdef jaws=aws
# but none of them worked unless I typed it in the terminal. So...
# (shrug) https://stackoverflow.com/a/4221640
compdef '_dispatch aws aws' jaws

# Make creating virtualenvs easier
alias mkvenv='python3 -m venv .venv && source .venv/bin/activate'

# The next line updates PATH for the Google Cloud SDK.
safeSource '$HOME/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
safeSource '$HOME/google-cloud-sdk/completion.zsh.inc'

# Created by `pipx` on 2021-08-02 19:01:02
export PATH="$PATH:$HOME/.local/bin"

# Don't take 20 minutes to install a single package
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=true

# Power up my shell
safeSource ${BREW_PATH}/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# function for setting terminal titles in OSX
function title {
  printf "\033]0;%s\007" "$1"
}

# Attempt to fix shell integration in VS Code (for cline/roo/et al)
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Include local configs
safeSource ~/.zshrc.local

# Docker exploration
alias dive='docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/joschi/dive'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
