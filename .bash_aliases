#!/bin/bash

# This file lists all the common alias that I use in my bash shell

# Change directory commands
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias dl='cd ~/Downloads'
alias ws='cd ~/workshop'
alias mkd='mkdir -p'

alias i='sudo apt install -y'
alias icy='sudo apt install'
alias update='sudo apt update -y'

# List directory contents
alias ls='ls --color=auto'
alias rmd='rm -rf'
alias kp='f(){ for port in "$@"; do lsof -ti:"$port" | xargs -r kill -9; done; }; f'
alias e='exit'

# Grep commands
alias grep='grep --color=auto'

# Reload bash configurations
alias reload='source ~/.bashrc'
alias r='reload'

# Docker commands
alias d='docker'
alias dc='docker compose'

# Maven
alias mci='mvn clean install'
alias mcixt='mvn clean install -DskipTests'
alias mdeps='mvn dependency:dependency'

# Node commands
alias ns='npm start'
alias nr='npm run'
alias ni='npm i'
alias nig='npm i -g'

# Gradlew commands
alias gb='./gradlew build'
alias gbxt='./gradlew build -x test'

# Create a alias to create executable scripts
alias ex='chmod +x'

alias bat="batcat"
alias n='nvim'
alias sn='sudo /opt/nvim-linux-x86_64/bin/nvim'
alias s='sudo'
