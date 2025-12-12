#!/bin/bash
# Wrapper script for opening files from yazi
# If in tmux, sends command to the Editor pane (Pane 2)
# Otherwise opens in current pane

FILE_PATH="$1"
LOG_FILE="/tmp/yazi-opener.log"
CURRENT_PANE_ID=$(tmux display-message -p "#{pane_id}")

echo "--- $(date) ---" >> "$LOG_FILE"
echo "Opening: $FILE_PATH" >> "$LOG_FILE"
echo "TMUX: $TMUX" >> "$LOG_FILE"
echo "Current Pane: $CURRENT_PANE_ID" >> "$LOG_FILE"

# Resolve absolute path if necessary
if [[ "$FILE_PATH" != /* ]]; then
    FILE_PATH="$(pwd)/$FILE_PATH"
fi

if [ -n "$TMUX" ]; then
    # We are in tmux
    echo "Detected TMUX session" >> "$LOG_FILE"
    
    # Try to find the pane with title "Editor" first
    # We use a loop to be safe against grep issues
    TARGET_PANE=""
    
    # Get all panes with ID and Title
    while read -r line; do
        p_id=$(echo "$line" | awk '{print $1}')
        p_title=$(echo "$line" | cut -d' ' -f2-)
        
        if [[ "$p_title" == "Editor" ]]; then
            TARGET_PANE="$p_id"
            echo "Found Editor pane by title: $TARGET_PANE" >> "$LOG_FILE"
            break
        fi
    done < <(tmux list-panes -F "#{pane_id} #{pane_title}")
    
    # If not found by title, default to pane index 2 (since base-index is 1)
    if [ -z "$TARGET_PANE" ]; then
        echo "Pane with title 'Editor' not found" >> "$LOG_FILE"
        
        # Check if we are currently in pane index 2
        CURRENT_INDEX=$(tmux display-message -p "#{pane_index}")
        if [ "$CURRENT_INDEX" -eq "2" ]; then
             echo "WARNING: Currently in pane 2. Assuming Editor is pane 1?" >> "$LOG_FILE"
             TARGET_PANE=".1"
        else
             echo "Defaulting to pane index 2" >> "$LOG_FILE"
             TARGET_PANE=".2"
        fi
    fi

    # Check if we are targeting ourselves (loop prevention)
    if [ "$TARGET_PANE" == "$CURRENT_PANE_ID" ]; then
        echo "ERROR: Target pane is current pane! Aborting to prevent loop." >> "$LOG_FILE"
        # Try next best guess: Pane 1 if we were 2, Pane 2 if we were 1
        if [ "$CURRENT_PANE_ID" == "%1" ]; then # Assuming %1 corresponds to index 2 usually
             TARGET_PANE=".1"
        else
             TARGET_PANE=".2"
        fi
        echo "Switched target to: $TARGET_PANE" >> "$LOG_FILE"
    fi

    # Check if nvim is already running in that pane
    CURRENT_CMD=$(tmux display-message -p -t "$TARGET_PANE" "#{pane_current_command}")
    echo "Current command in target pane ($TARGET_PANE): $CURRENT_CMD" >> "$LOG_FILE"

    if [[ "$CURRENT_CMD" == *"nvim"* ]]; then
        echo "nvim running, opening in new tab" >> "$LOG_FILE"
        tmux send-keys -t "$TARGET_PANE" Escape
        tmux send-keys -t "$TARGET_PANE" ":tabnew $FILE_PATH" C-m
    else
        echo "nvim not running, starting nvim" >> "$LOG_FILE"
        tmux send-keys -t "$TARGET_PANE" C-c
        tmux send-keys -t "$TARGET_PANE" "nvim '$FILE_PATH'" C-m
    fi
    
    # Select the pane to focus it
    tmux select-pane -t "$TARGET_PANE"
else
    # Not in tmux, just open with nvim
    echo "Not in TMUX, opening locally" >> "$LOG_FILE"
    nvim "$FILE_PATH"
fi
