#!/usr/bin/env bash

# Make sure BQN symbols are activated
setxkbmap -layout us,bqn -option grp:switch

# BQN
BQN_CMD="clear; figlet 'BQN' | command lolcat; cbqn --version; exec cbqn"
guake --new-tab=. --rename-current-tab="BQN" --execute-command="$BQN_CMD"

# IPython
IPY_CMD="clear; figlet 'IPython' | command lolcat; python --version; exec ipython --no-banner"
guake --new-tab=. --rename-current-tab="IPython" --execute-command="$IPY_CMD"

# Julia
JULIA_CMD="clear; figlet 'Julia' | command lolcat; julia --version; exec julia --banner=no"
guake --new-tab=. --rename-current-tab="Julia" --execute-command="$JULIA_CMD"

# Numbat
NBT_CMD="clear; figlet 'Numbat' | command lolcat; numbat --version; exec numbat --intro-banner off"
guake --new-tab=. --rename-current-tab="Numbat" --execute-command="$NBT_CMD"

# Kill the original boring Fish tab
guake --select-tab=0
