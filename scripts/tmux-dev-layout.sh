#!/bin/bash
# VS Code-like tmux layout automation
# Creates a development session with file browser, code editor, and terminal

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
SESSION_NAME="${1:-dev}"
TARGET_DIR="${2:-$(pwd)}"
LAYOUT_NAME="vscode-layout"

# Check if tmux is available
if ! command -v tmux >/dev/null 2>&1; then
    echo -e "${RED}❌ tmux is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${BLUE}🚀 Setting up VS Code-like tmux layout...${NC}"
echo -e "${BLUE}Session: ${GREEN}$SESSION_NAME${NC}"
echo -e "${BLUE}Directory: ${GREEN}$TARGET_DIR${NC}"

# Validate target directory
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${YELLOW}⚠️  Directory '$TARGET_DIR' does not exist. Using current directory.${NC}"
    TARGET_DIR="$(pwd)"
fi

# Kill existing session if it exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo -e "${YELLOW}🔄 Session '$SESSION_NAME' exists. Attaching...${NC}"
    exec tmux attach-session -t "$SESSION_NAME"
fi

# Create new session
echo -e "${BLUE}📱 Creating new tmux session: $SESSION_NAME${NC}"
tmux new-session -d -s "$SESSION_NAME" -c "$TARGET_DIR"

# Rename the first window
tmux rename-window -t "$SESSION_NAME" "dev"

# Create the VS Code-like layout
echo -e "${BLUE}🏗️  Building layout...${NC}"

# Split vertically (sidebar | main area) - 25% left, 75% right
tmux split-window -t "$SESSION_NAME:dev" -h -p 75 -c "$TARGET_DIR"

# Split the right pane horizontally (code area | terminal) - 70% top, 30% bottom
tmux split-window -t "$SESSION_NAME:dev.right" -v -p 30 -c "$TARGET_DIR"

# Store pane IDs for reliable targeting
PANE_FILES=$(tmux list-panes -t "$SESSION_NAME:dev" -F "#{pane_index}" | head -1)
PANE_CODE=$(tmux list-panes -t "$SESSION_NAME:dev" -F "#{pane_index}" | sed -n '2p')
PANE_TERMINAL=$(tmux list-panes -t "$SESSION_NAME:dev" -F "#{pane_index}" | tail -1)

# Configure each pane with error checking
echo -e "${BLUE}🗂️  Setting up file browser (left pane)...${NC}"
if tmux list-panes -t "$SESSION_NAME:dev" | grep -q "^$PANE_FILES:"; then
    tmux send-keys -t "$SESSION_NAME:dev.$PANE_FILES" "clear" Enter
    tmux send-keys -t "$SESSION_NAME:dev.$PANE_FILES" "echo '📁 File Browser - Use: lf, ranger, or tree'" Enter

    # Check for available file managers and set up the best one
    if command -v lf >/dev/null 2>&1; then
        tmux send-keys -t "$SESSION_NAME:dev.$PANE_FILES" "echo 'Starting lf file manager...'" Enter
        tmux send-keys -t "$SESSION_NAME:dev.$PANE_FILES" "lf" Enter
    elif command -v ranger >/dev/null 2>&1; then
        tmux send-keys -t "$SESSION_NAME:dev.$PANE_FILES" "echo 'Starting ranger file manager...'" Enter
        tmux send-keys -t "$SESSION_NAME:dev.$PANE_FILES" "ranger" Enter
    else
        tmux send-keys -t "$SESSION_NAME:dev.$PANE_FILES" "echo 'Install lf or ranger for better file browsing'" Enter
        tmux send-keys -t "$SESSION_NAME:dev.$PANE_FILES" "echo 'Using tree for now:'" Enter
        tmux send-keys -t "$SESSION_NAME:dev.$PANE_FILES" "tree -L 2" Enter
    fi
fi

echo -e "${BLUE}💻 Setting up code editor (top-right pane)...${NC}"
if tmux list-panes -t "$SESSION_NAME:dev" | grep -q "^$PANE_CODE:"; then
    tmux send-keys -t "$SESSION_NAME:dev.$PANE_CODE" "clear" Enter
    tmux send-keys -t "$SESSION_NAME:dev.$PANE_CODE" "echo '💻 Code Editor - Ready for development!'" Enter
    tmux send-keys -t "$SESSION_NAME:dev.$PANE_CODE" "echo 'Use: nvim . or nvim filename'" Enter
fi

echo -e "${BLUE}⚡ Setting up terminal (bottom-right pane)...${NC}"
if tmux list-panes -t "$SESSION_NAME:dev" | grep -q "^$PANE_TERMINAL:"; then
    tmux send-keys -t "$SESSION_NAME:dev.$PANE_TERMINAL" "clear" Enter
    tmux send-keys -t "$SESSION_NAME:dev.$PANE_TERMINAL" "echo '⚡ Terminal - Ready for commands!'" Enter
fi

# Set pane titles with error checking
if tmux list-panes -t "$SESSION_NAME:dev" | grep -q "^$PANE_FILES:"; then
    tmux select-pane -t "$SESSION_NAME:dev.$PANE_FILES" -T "Files"
fi
if tmux list-panes -t "$SESSION_NAME:dev" | grep -q "^$PANE_CODE:"; then
    tmux select-pane -t "$SESSION_NAME:dev.$PANE_CODE" -T "Code"
fi
if tmux list-panes -t "$SESSION_NAME:dev" | grep -q "^$PANE_TERMINAL:"; then
    tmux select-pane -t "$SESSION_NAME:dev.$PANE_TERMINAL" -T "Terminal"
fi

# Save the layout for future use
echo -e "${BLUE}💾 Saving layout as '$LAYOUT_NAME'...${NC}"
mkdir -p ~/.tmux-layouts
tmux list-windows -t "$SESSION_NAME" -F "#{window_index}:#{window_name}:#{window_layout}" > ~/.tmux-layouts/"$LAYOUT_NAME"

# Focus on the code pane initially
if tmux list-panes -t "$SESSION_NAME:dev" | grep -q "^$PANE_CODE:"; then
    tmux select-pane -t "$SESSION_NAME:dev.$PANE_CODE"
fi

echo -e "\n${GREEN}✅ VS Code-like tmux layout ready!${NC}"
echo -e "\n${BLUE}Layout Overview:${NC}"
echo -e "${GREEN}├── Left pane (25%):${NC} File browser (lf/ranger/tree)"
echo -e "${GREEN}├── Top-right (52.5%):${NC} Code editor area"
echo -e "${GREEN}└── Bottom-right (22.5%):${NC} Terminal commands"

echo -e "\n${BLUE}Navigation:${NC}"
echo -e "${GREEN}• Ctrl+Q + h/j/k/l:${NC} Navigate panes"
echo -e "${GREEN}• Ctrl+Q + z:${NC} Zoom current pane"
echo -e "${GREEN}• Ctrl+Q + [:${NC} Enter copy mode"
echo -e "${GREEN}• Ctrl+Q + d:${NC} Detach session"

echo -e "\n${BLUE}Quick Commands:${NC}"
echo -e "${GREEN}• Files pane:${NC} q (quit file manager), h/j/k/l (navigate)"
echo -e "${GREEN}• Code pane:${NC} nvim ., nvim filename"
echo -e "${GREEN}• Terminal pane:${NC} git, npm, build commands"

echo -e "\n${BLUE}Session Management:${NC}"
echo -e "${GREEN}• Attach:${NC} tmux attach-session -t $SESSION_NAME"
echo -e "${GREEN}• Detach:${NC} Ctrl+Q + d"
echo -e "${GREEN}• Kill:${NC} tmux kill-session -t $SESSION_NAME"

echo -e "\n${YELLOW}💡 Pro tip: Layout saved as '$LAYOUT_NAME' for future use!${NC}"

# Attach to the session
exec tmux attach-session -t "$SESSION_NAME"