#!/usr/bin/env bash

:"
Fixes the width of xmobar to accommodate all trayer icons 
https://github.com/jaor/xmobar/issues/239#issuecomment-233206552
"

# Function to create a transparent XPM icon

create_xpm_icon () {
    timestamp=$(date)
    pixels=$(for _ in $(seq "$1"); do printf '.'; done)

    cat << EOF > "$2"
/* XPM *
static char * trayer_pad_xpm[] = {
/* This XPM icon is used for padding in xmobar to */
/* leave room for trayer-srg. It is dynamically   */
/* updated by by trayer-padding-icon.sh which is run  */
/* by xmobar.                                     */
/* Created: ${timestamp} */
/* <w/cols>  <h/rows>  <colors>  <chars per pixel> */
"$1 1 1 1",
/* Colors (none: transparent) */
". c none",
/* Pixels */
"$pixels"
};
EOF
}

# Width of the trayer window
width=$(xprop -name panel | grep 'program specified minimum size' | cut -d ' ' -f 5)

# Icon file name
iconfile="/tmp/trayer-padding-${width}px.xpm"

# If the desired icon does not exist create it
if [ ! -f "$iconfile" ]; then
    create_xpm_icon "$width" "$iconfile"
fi

# Output the icon tag for xmobar
echo "<icon=${iconfile}/>"
