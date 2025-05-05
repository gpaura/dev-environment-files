#!/bin/bash

THEME_FILE="$HOME/.config/wezterm/theme"
mkdir -p "$(dirname "$THEME_FILE")"

# Check current theme
if [ -f "$THEME_FILE" ] && grep -q "dark" "$THEME_FILE"; then
    echo "light" > "$THEME_FILE"
    echo "Switching to Light Theme 🌞"
else
    echo "dark" > "$THEME_FILE"
    echo "Switching to Dark Theme 🌙"
fi

# For Ghostty - send reload signal
if pgrep ghostty >/dev/null 2>&1; then
    killall -USR1 ghostty 2>/dev/null && \
    echo "Signal sent to reload Ghostty configuration" || \
    echo "Note: Could not reload Ghostty, theme will apply on next launch"
fi

# For WezTerm, create a touch file that WezTerm can watch for changes
touch "$HOME/.config/wezterm/wezterm.lua"
echo "Theme file updated. Changes will apply to new terminal windows."