#!/bin/bash
# Robust 3-column tmux layout (Index-agnostic)
# Structure:
# | Left (18%) | Editor (64%) | Right (18%) |
# |            |--------------|             |
# |            | Term (32%)   |             |

set -e

# Configuration
SESSION_NAME="${1:-dev}"
TARGET_DIR="${2:-$(pwd)}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Ensure tmux is available
if ! command -v tmux >/dev/null 2>&1; then
    echo "❌ tmux not found."
    exit 1
fi

# 1. Create Session or Switch
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo -e "${BLUE}🔄 Switching to existing session: $SESSION_NAME${NC}"
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$SESSION_NAME"
    else
        exec tmux attach-session -t "$SESSION_NAME"
    fi
    exit 0
fi

echo -e "${BLUE}🚀 Creating layout for: ${GREEN}$SESSION_NAME${NC}"

# Create detached session
# We capture the ID of the very first pane created (The Left Sidebar)
# -P -F "#{pane_id}" prints the unique ID (e.g., %0)
tmux new-session -d -s "$SESSION_NAME" -c "$TARGET_DIR"
tmux rename-window -t "$SESSION_NAME" "dev"

# Get the first pane's ID (It is the only one currently)
PANE_LEFT=$(tmux list-panes -t "$SESSION_NAME" -F "#{pane_id}")

# 2. Split LEFT to create the big area on the right
# New pane becomes the temporary "Center+Right" area
# We split -h (horizontal) at 82% width
PANE_CENTER_WRAPPER=$(tmux split-window -t "$PANE_LEFT" -h -p 82 -c "$TARGET_DIR" -P -F "#{pane_id}")

# 3. Split that Wrapper to create the Right Sidebar
# We need the Right Sidebar to be 18% of the TOTAL screen.
# Since the wrapper is 82% of the screen, we take ~22% of IT.
PANE_RIGHT=$(tmux split-window -t "$PANE_CENTER_WRAPPER" -h -p 22 -c "$TARGET_DIR" -P -F "#{pane_id}")

# Now, PANE_CENTER_WRAPPER has shrunk and is actually just the CENTER column.
# Let's rename the variable for clarity.
PANE_EDITOR="$PANE_CENTER_WRAPPER"

# 4. Split the Editor to create the Terminal at the bottom
# Split -v (vertical) at 32% height
PANE_TERMINAL=$(tmux split-window -t "$PANE_EDITOR" -v -p 32 -c "$TARGET_DIR" -P -F "#{pane_id}")

# --- Setup Pane Text ---
# Now we have exact IDs: $PANE_LEFT, $PANE_EDITOR, $PANE_TERMINAL, $PANE_RIGHT

tmux send-keys -t "$PANE_LEFT" "clear; echo '📁 LEFT'" Enter
tmux select-pane -t "$PANE_LEFT" -T "Left"

tmux send-keys -t "$PANE_EDITOR" "clear; echo '💻 EDITOR'" Enter
tmux select-pane -t "$PANE_EDITOR" -T "Editor"

tmux send-keys -t "$PANE_TERMINAL" "clear; echo '⚡ TERMINAL'" Enter
tmux select-pane -t "$PANE_TERMINAL" -T "Terminal"

tmux send-keys -t "$PANE_RIGHT" "clear; echo '📊 RIGHT'" Enter
tmux select-pane -t "$PANE_RIGHT" -T "Right"

# Final focus on Editor
tmux select-pane -t "$PANE_EDITOR"

echo -e "${GREEN}✅ Layout built successfully!${NC}"

# Attach
if [ -n "$TMUX" ]; then
    tmux switch-client -t "$SESSION_NAME"
else
    exec tmux attach-session -t "$SESSION_NAME"
fi