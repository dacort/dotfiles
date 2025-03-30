# dotfiles
My (n)ever-changing dotfiles / bare git style

## Overview

I've tried a few variations of dotfiles in the past, but I never really liked having to manage my config files with more code.

So in hunting around for solutions (and trying `yadm` as well) I came across the [git bare repo](https://www.atlassian.com/git/tutorials/dotfiles) approach.

I quite liked it, so this is my attempt at managing my dotfiles across 1-n machines where currently `n=2`.

## Bootstrapping

- Clone the repo (without auth)

```shell
git clone --bare https://github.com/dacort/dotfiles.git .cfg
git --git-dir=$HOME/.cfg --work-tree=$HOME checkout -f
```

- Update your shell and do not show untracked files

```shell
source ~/.zshrc
git config --local status.showUntrackedFiles no
```

- Run the macos installation script

```shell
./.macos
```

- After creating/adding a new SSH key to GH, switch the origin and push any changes

```shell
git remote set-url origin git@github.com:dacort/dotfiles.git
```
