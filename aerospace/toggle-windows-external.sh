#!/bin/bash
# Toggle between current workspace and Windows App on external monitor (workspace 9)
# Mimics macOS trackpad 4-finger swipe to Windows App screen

current_workspace=$(aerospace list-workspaces --focused)

if [ "$current_workspace" = "9" ]; then
    # If already on Windows App workspace, go back to previous workspace
    aerospace workspace-back-and-forth
else
    # Otherwise, jump to Windows App on external monitor
    aerospace workspace 9
fi
