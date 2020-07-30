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


## GIT SHORTCUTS ##

alias gs='git status -sb -uno'
alias gd='git diff'
alias gp='git push origin HEAD'
alias gpu='git push -u'


## VIRTUAL ENVIRONMENTS ##

# nodenv init
if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi


## ALIASES ##

alias config='/usr/bin/git --git-dir='${HOME}'/.cfg/ --work-tree='${HOME}
