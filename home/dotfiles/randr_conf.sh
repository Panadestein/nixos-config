#!/usr/bin/env bash

: '
A script to setup a multihead ensuring one monitor
at the time, defaulting to external monitors.
The script is unfortunately hardware dependent,
and implements a particular setup I prefer.
'

# Labels

LAP="eDP"
DP0="DisplayPort-0"
DP1="DisplayPort-1"
HDMI="HDMI-A-0"

# Get number of plugged monitors

MONS=$(xrandr -q | grep -c " connected")

# Check connected monitors and apply configuration

if [ "$MONS" -gt 2 ]; then
    xrandr --output "$LAP" --off\
	   --output "$HDMI" --off\
	   --output "$DP0" --auto --primary
elif [ "$MONS" -eq 2 ]; then
    if xrandr | grep "$DP0 connected"; then
	xrandr --output "$LAP" --off\
	       --output "$DP0" --auto --primary
    elif xrandr | grep "$DP1 connected"; then
	xrandr --output "$LAP" --off\
	       --output "$DP1" --auto --primary
    elif xrandr | grep "$HDMI connected"; then
	xrandr --output "$LAP" --off\
	       --output "$HDMI" --auto --primary
    fi
else
    xrandr --output "$LAP" --auto --primary\
	   --output "$DP0" --off\
	   --output "$DP1" --off\
	   --output "$HDMI" --off
fi
