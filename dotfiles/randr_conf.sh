#!/usr/bin/env bash

: '
A script to ensure the use of only one monitor
at the time, defaulting to external monitors.
The script is unfortunately hardware dependent,
and implements a particular setup I prefer.
'

# Labels

LAP=eDP
ARB=DisplayPort-0
HAU=HDMI-A-0

# Get number of plugged monitors

MONS=$(xrandr -q | grep -c " connected")

# Check connected monitors and apply configuration

if [ "$MONS" -gt 2 ]; then
    xrandr --output "$LAP" --off\
	   --output "$HAU" --off\
	   --output "$ARB" --auto
elif [ "$MONS" -eq 2 ]; then
    if xrandr | grep "$ARB connected"; then
	xrandr --output "$LAP" --off\
	       --output "$ARB" --auto
    elif xrandr | grep "$HAU connected"; then
	xrandr --output "$LAP" --off\
	       --output "$HAU" --auto
    fi
else
    xrandr --output "$LAP" --auto\
	   --output "$ARB" --off\
	   --output "$HAU" --off
fi

# Restore wall paper whatever outcome

nitrogen --restore
