#!/usr/bin/env bash

# Make sure BQN symbols are activated
setxkbmap -layout us,bqn -option grp:switch

# BQN
BQN_CMD="clear; figlet 'BQN' | lolcat 2>/dev/null; cbqn --version; exec cbqn"
guake --new-tab=. --rename-current-tab="BQN" --execute-command="$BQN_CMD"

# IPython
guake --new-tab=. --rename-current-tab="IPython" --execute-command="clear; ipython"

# Cleanup
guake --select-tab=0
