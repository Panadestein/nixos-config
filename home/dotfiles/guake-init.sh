#!/usr/bin/env bash

# Make sure BQN symbols are activated
setxkbmap -layout us,bqn -option grp:switch

# BQN
BQN_CMD="clear; figlet 'BQN' | command lolcat; cbqn --version; exec cbqn"
guake --new-tab=. --rename-current-tab="BQN" --execute-command="$BQN_CMD"

# IPython
IPY_CMD="clear; figlet 'IPython' | command lolcat; exec ipython"
guake --new-tab=. --rename-current-tab="IPython" --execute-command="$IPY_CMD"

# Cleanup
guake --select-tab=0
