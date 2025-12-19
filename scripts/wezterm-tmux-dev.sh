#!/bin/bash
# WezTerm keybinding helper for tmux dev session

# Get current directory (will be passed as argument or use PWD)
TARGET_DIR="${1:-$PWD}"

# Check if we're in tmux
if [ -n "$TMUX" ]; then
    # In tmux - switch to dev session or create it
    if tmux has-session -t dev 2>/dev/null; then
        tmux switch-client -t dev
    else
        "$HOME/.config/scripts/tmux-dev-layout.sh" dev "$TARGET_DIR"
    fi
else
    # Not in tmux - attach or create
    if tmux has-session -t dev 2>/dev/null; then
        exec tmux attach-session -t dev
    else
        exec "$HOME/.config/scripts/tmux-dev-layout.sh" dev "$TARGET_DIR"
    fi
fi
