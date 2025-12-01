#!/bin/bash
# Tmux session selector with VS Code-like layout creation
# Provides an interactive menu to select existing sessions or create new ones

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAYOUT_SCRIPT="$SCRIPT_DIR/tmux-dev-layout.sh"

# Check if tmux is available
if ! command -v tmux >/dev/null 2>&1; then
    echo -e "${RED}❌ tmux is not installed or not in PATH${NC}"
    exit 1
fi

# Function to get existing sessions
get_sessions() {
    tmux list-sessions -F "#{session_name}" 2>/dev/null || true
}

# Function to display session menu
show_session_menu() {
    local sessions=()
    local session_count=0

    # Get existing sessions
    while IFS= read -r session; do
        if [[ -n "$session" ]]; then
            sessions+=("$session")
            ((session_count++))
        fi
    done < <(get_sessions)

    # Build menu options
    local options=()
    local option_count=0

    # Add existing sessions to menu
    if [[ $session_count -gt 0 ]]; then
        echo -e "${BLUE}📋 Existing tmux sessions:${NC}"
        for i in "${!sessions[@]}"; do
            local num=$((i + 1))
            echo -e "${GREEN}  $num) ${sessions[i]}${NC}"
            options+=("attach:${sessions[i]}")
            ((option_count++))
        done
        echo ""
    fi

    # Add create new session option
    local new_option_num=$((option_count + 1))
    echo -e "${BLUE}🆕 Create new session:${NC}"
    echo -e "${GREEN}  $new_option_num) Create new VS Code-like session${NC}"
    options+=("create:new")

    # Add quit option
    local quit_option_num=$((option_count + 2))
    echo -e "${YELLOW}  $quit_option_num) Cancel${NC}"
    options+=("quit")

    echo ""
    echo -e "${BLUE}Choose an option (1-$quit_option_num): ${NC}"

    # Read user choice
    local choice
    read -r choice

    # Validate choice
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ $choice -lt 1 ]] || [[ $choice -gt $quit_option_num ]]; then
        echo -e "${RED}❌ Invalid choice. Please select a number between 1 and $quit_option_num${NC}"
        return 1
    fi

    # Execute choice
    local selected_option="${options[$((choice - 1))]}"
    local action="${selected_option%%:*}"
    local target="${selected_option#*:}"

    case "$action" in
        "attach")
            echo -e "${GREEN}🔗 Attaching to session: $target${NC}"
            exec tmux attach-session -t "$target"
            ;;
        "create")
            create_new_session
            ;;
        "quit")
            echo -e "${YELLOW}👋 Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown action: $action${NC}"
            return 1
            ;;
    esac
}

# Function to create new session
create_new_session() {
    echo ""
    echo -e "${BLUE}🆕 Creating new tmux session${NC}"
    echo -e "${BLUE}Enter session name: ${NC}"

    local session_name
    read -r session_name

    # Validate session name
    if [[ -z "$session_name" ]]; then
        echo -e "${RED}❌ Session name cannot be empty${NC}"
        return 1
    fi

    # Check if session already exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Session '$session_name' already exists. Attaching...${NC}"
        exec tmux attach-session -t "$session_name"
        return
    fi

    # Ask for directory
    echo -e "${BLUE}Enter working directory (press Enter for current directory): ${NC}"
    local work_dir
    read -r work_dir

    if [[ -z "$work_dir" ]]; then
        work_dir="$(pwd)"
    fi

    # Validate directory
    if [[ ! -d "$work_dir" ]]; then
        echo -e "${RED}❌ Directory '$work_dir' does not exist${NC}"
        return 1
    fi

    # Create session with VS Code-like layout
    echo -e "${GREEN}🚀 Creating VS Code-like layout for session '$session_name'...${NC}"

    if [[ -x "$LAYOUT_SCRIPT" ]]; then
        exec "$LAYOUT_SCRIPT" "$session_name" "$work_dir"
    else
        echo -e "${RED}❌ Layout script not found or not executable: $LAYOUT_SCRIPT${NC}"
        echo -e "${BLUE}Creating basic session instead...${NC}"
        tmux new-session -d -s "$session_name" -c "$work_dir"
        exec tmux attach-session -t "$session_name"
    fi
}

# Main function
main() {
    echo -e "${BLUE}🖥️  Tmux Session Manager${NC}"
    echo -e "${BLUE}========================${NC}"
    echo ""

    # Check if we're already in a tmux session
    if [[ -n "$TMUX" ]]; then
        echo -e "${YELLOW}⚠️  You're already in a tmux session: $(tmux display-message -p '#S')${NC}"
        echo -e "${BLUE}Choose what to do:${NC}"
        echo -e "${GREEN}  1) Switch to another session${NC}"
        echo -e "${GREEN}  2) Create new session${NC}"
        echo -e "${YELLOW}  3) Stay in current session${NC}"
        echo ""
        echo -e "${BLUE}Choose an option (1-3): ${NC}"

        local choice
        read -r choice

        case "$choice" in
            1)
                echo ""
                show_session_menu
                ;;
            2)
                create_new_session
                ;;
            3)
                echo -e "${GREEN}👍 Staying in current session${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice${NC}"
                exit 1
                ;;
        esac
    else
        show_session_menu
    fi
}

# Run main function
main "$@"