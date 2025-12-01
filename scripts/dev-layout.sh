#!/bin/bash
# VS Code-like Development Layout for WezTerm
# Usage: ./dev-layout.sh [directory]

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default to current directory if no argument provided
TARGET_DIR="${1:-$(pwd)}"

# Validate directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${YELLOW}Warning: Directory '$TARGET_DIR' does not exist. Using current directory.${NC}"
    TARGET_DIR="$(pwd)"
fi

echo -e "${BLUE}🚀 Setting up VS Code-like layout in: ${GREEN}$TARGET_DIR${NC}"

# Change to target directory
cd "$TARGET_DIR"

# Method 1: WezTerm CLI (if available)
if command -v wezterm >/dev/null 2>&1; then
    echo -e "${BLUE}📱 Using WezTerm CLI method...${NC}"

    # Create vertical split (sidebar on left, main area on right)
    PANE_ID_RIGHT=$(wezterm cli split-pane --right --percent 75)

    # Split the right pane horizontally (code on top, terminal on bottom)
    PANE_ID_TERMINAL=$(wezterm cli split-pane --pane-id "$PANE_ID_RIGHT" --bottom --percent 30)

    # Configure each pane
    echo -e "${BLUE}🗂️  Setting up file browser in left pane...${NC}"
    printf "# File Browser Pane - Use 'lf', 'ranger', or 'tree'\nclear\n" | wezterm cli send-text

    # Go to code pane (top right)
    wezterm cli activate-pane --pane-id "$PANE_ID_RIGHT"
    echo -e "${BLUE}💻 Setting up code editor in main pane...${NC}"
    printf "# Code Editor Pane - Use 'nvim .' or your preferred editor\nclear\necho 'Ready for coding! 🚀'\n" | wezterm cli send-text

    # Go to terminal pane (bottom right)
    wezterm cli activate-pane --pane-id "$PANE_ID_TERMINAL"
    echo -e "${BLUE}⚡ Setting up terminal in bottom pane...${NC}"
    printf "# Terminal Commands Pane\nclear\necho 'Terminal ready! ⚡'\n" | wezterm cli send-text

    # Return focus to file browser pane
    wezterm cli activate-pane --pane-id 0

else
    echo -e "${YELLOW}⚠️  WezTerm CLI not available. Using manual setup instructions...${NC}"

    echo -e "${BLUE}Manual Setup Instructions:${NC}"
    echo -e "${GREEN}1.${NC} Press ${YELLOW}Cmd+Shift+D${NC} to split vertically (creates sidebar)"
    echo -e "${GREEN}2.${NC} Press ${YELLOW}Cmd+Option+Right${NC} to move to right pane"
    echo -e "${GREEN}3.${NC} Press ${YELLOW}Cmd+D${NC} to split horizontally (creates bottom terminal)"
    echo -e "${GREEN}4.${NC} Use ${YELLOW}Cmd+Option+Arrow${NC} keys to navigate between panes"
fi

echo -e "\n${GREEN}✅ Layout setup complete!${NC}"
echo -e "\n${BLUE}Recommended tools for each pane:${NC}"
echo -e "${GREEN}📁 Left (Files):${NC} lf, ranger, tree, or fd+fzf"
echo -e "${GREEN}💻 Top-right (Code):${NC} nvim, code, or your preferred editor"
echo -e "${GREEN}⚡ Bottom-right (Terminal):${NC} git commands, build tools, monitoring"

echo -e "\n${BLUE}Key bindings:${NC}"
echo -e "${GREEN}Navigation:${NC} Cmd+Option+Arrow keys"
echo -e "${GREEN}New split:${NC} Cmd+D (horizontal), Cmd+Shift+D (vertical)"
echo -e "${GREEN}Close pane:${NC} Cmd+Shift+W"
echo -e "${GREEN}Zoom pane:${NC} Cmd+Shift+Z"