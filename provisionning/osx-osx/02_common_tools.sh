#!/usr/bin/env bash

echo "Installing git…"
brew install git

echo "Installing zsh…"
brew install zsh

echo "Installing rbenv…"
brew install rbenv

echo "Installing ruby-build…"
brew install ruby-build

echo "Installing wget…"
brew install wget

echo "Installing tree…"
brew install tree

echo "Installing oh-my-zsh…"
curl -L http://install.ohmyz.sh | sh

cat << EOF > ~/.oh-my-zsh/themes/hackademy.zsh-theme
if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="033"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$FG[$NCOLOR]%}hackademy%{$reset_color%}@%{$FG[248]%}%m\
%{$reset_color%}:%{$fg[magenta]%}%~\
$(git_prompt_info) \
%{$fg[red]%}%(!.#.$)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}○%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"
EOF

cat << EOF > ~/.zshrc
# ensure to use 256 colors
export TERM=xterm-256color

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="hackademy"

plugins=(git git-flow rbenv brew osx pow gem vagrant)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

alias l="ls -laFGh"
alias e="vim"
alias g="git"
alias o="open"
alias rm='rm -i'
alias r='rake'
alias be="bundle exec"

export PATH="$HOME/.rbenv/bin:$PATH"
EOF

echo 'eval "$(rbenv init -)"' >> ~/.zshrc
