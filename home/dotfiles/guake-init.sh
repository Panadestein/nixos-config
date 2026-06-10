#!/usr/bin/env bash

# Make sure BQN symbols are activated
setxkbmap -layout us,bqn -option grp:switch

# Fish
FISH_CMD="clear; figlet 'Fish' | command lolcat; exec fish"
guake --new-tab=. --rename-current-tab="Fish" --execute-command="$FISH_CMD"

# BQN
BQN_CMD="clear; figlet 'BQN' | command lolcat; cbqn --version; exec cbqn"
guake --new-tab=. --rename-current-tab="BQN" --execute-command="$BQN_CMD"

# IPython
IPY_CMD="clear; figlet 'IPython' | command lolcat; exec ipython"
guake --new-tab=. --rename-current-tab="IPython" --execute-command="$IPY_CMD"

# Julia
JULIA_CMD="clear; figlet 'Julia' | command lolcat; exec julia"
guake --new-tab=. --rename-current-tab="Julia" --execute-command="$JULIA_CMD"

# Numbat
NBT_CMD="clear; figlet 'Numbat' | command lolcat; exec numbat --intro-banner off"
guake --new-tab=. --rename-current-tab="Numbat" --execute-command="$NBT_CMD"

# Kill the original boring Fish tab
guake --select-tab=0
guake --execute-command="exit"

# Land on the new Fish tab, which should now be tab 0
guake --select-tab=0
