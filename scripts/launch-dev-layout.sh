#!/bin/bash

# Path to the layout script
LAYOUT_SCRIPT="$HOME/.config/scripts/tmux-dev-layout.sh"

# Check for Ghostty
if [ -d "/Applications/Ghostty.app" ]; then
    # Launch Ghostty with the layout script
    # We use the binary directly to ensure arguments are passed correctly
    /Applications/Ghostty.app/Contents/MacOS/ghostty -e "$LAYOUT_SCRIPT" >/dev/null 2>&1 &
    exit 0
fi

# Fallback to WezTerm
if [ -d "/Applications/WezTerm.app" ]; then
    # Launch WezTerm with the layout script
    /Applications/WezTerm.app/Contents/MacOS/wezterm start -- "$LAYOUT_SCRIPT" >/dev/null 2>&1 &
    exit 0
fi

# Fallback if no preferred terminal is found
echo "No supported terminal (Ghostty/WezTerm) found."
