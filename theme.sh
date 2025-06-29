#!/bin/bash

# Theme Switcher for Ghostty and WezTerm
# This script updates themes by directly modifying the config files

# Paths
WEZTERM_THEME_FILE="$HOME/.config/wezterm/theme"
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"

# Create directories if they don't exist
mkdir -p "$(dirname "$WEZTERM_THEME_FILE")"

# Read current theme or default to light (since that's working)
CURRENT_THEME="light"
if [ -f "$WEZTERM_THEME_FILE" ]; then
    CURRENT_THEME=$(cat "$WEZTERM_THEME_FILE" | tr -d '[:space:]')
fi

# Define themes
DARK_THEME='# Dark theme settings
foreground = "#F8F8F2"
background = "#1A1B26"

# Cursor
cursor-color = "#FF79C6"
cursor-text = "#282A36"

# Selection
selection-background = "#44475A"
selection-foreground = "#F8F8F2"

# ANSI Colors (0-7)
palette = 0=#414868
palette = 1=#FF5555
palette = 2=#50FA7B
palette = 3=#FF40A3
palette = 4=#BD93F9
palette = 5=#FF79C6
palette = 6=#8BE9FD
palette = 7=#ACAAB6

# Bright Colors (8-15)
palette = 8=#565F89
palette = 9=#F7768E
palette = 10=#A9FF68
palette = 11=#FF66C7
palette = 12=#BD93F9
palette = 13=#FC9867
palette = 14=#78DCE8
palette = 15=#F8F8F2

# Indexed colors for special highlighting
palette = 16=#FFB86C
palette = 17=#FF9E64
palette = 18=#BB9AF7
palette = 19=#FC9867
palette = 20=#FF79C6
palette = 21=#AB9DF2
palette = 22=#FF75A0
palette = 23=#9ECE6A
palette = 24=#7DCFFF
palette = 25=#73DACA'

LIGHT_THEME='# Light theme settings
foreground = "#2D2A2E"
background = "#FAFAFA"
cursor-color = "#FF2D76"
cursor-text = "#FFFFFF"
selection-background = "#E0E0E0"
selection-foreground = "#2D2A2E"

# ANSI Colors (0-7)
palette = 0=#5A5257
palette = 1=#FF0F60
palette = 2=#3D8A0C
palette = 3=#FF40A3
palette = 4=#9D50FF
palette = 5=#FF3388
palette = 6=#19B3CD
palette = 7=#F8F8F2

# Bright Colors (8-15)
palette = 8=#7A686E
palette = 9=#F5623D
palette = 10=#4E9F2F
palette = 11=#FF66C7
palette = 12=#B77BFF
palette = 13=#FF66C7
palette = 14=#58DDEF
palette = 15=#FFFFFF

# Indexed colors (16-25)
palette = 16=#FF9000
palette = 17=#C49E3F
palette = 18=#AA7800
palette = 19=#FF42A1
palette = 20=#A64DFF
palette = 21=#8F95A0
palette = 22=#845AC7
palette = 23=#097CCD
palette = 24=#FF6200
palette = 25=#45C7FF'

# Determine new theme
if [ "$CURRENT_THEME" = "dark" ]; then
    NEW_THEME="light"
    THEME_CONTENT="$LIGHT_THEME"
    echo "Switching to Light Theme 🌞"
else
    NEW_THEME="dark" 
    THEME_CONTENT="$DARK_THEME"
    echo "Switching to Dark Theme 🌙"
fi

# Update WezTerm theme
echo "$NEW_THEME" > "$WEZTERM_THEME_FILE"

# Function to update Ghostty config
update_ghostty_theme() {
    if [ ! -f "$GHOSTTY_CONFIG" ]; then
        echo "Error: Ghostty config file not found!"
        return 1
    fi
    
    # Create a temporary file
    local temp_config="${GHOSTTY_CONFIG}.tmp"
    
    # Copy everything except the theme section
    awk '
    BEGIN { in_theme = 0 }
    /# THEME_START/ { in_theme = 1; next }
    /# THEME_END/ { in_theme = 0; next }
    !in_theme { print }
    ' "$GHOSTTY_CONFIG" > "$temp_config"
    
    # Find where to insert the theme (after the theme configuration comment)
    local insert_line=$(grep -n "# THEME CONFIGURATION" "$temp_config" | cut -d: -f1)
    
    if [ -n "$insert_line" ]; then
        # Insert the new theme
        {
            head -n $((insert_line + 2)) "$temp_config"
            echo "# THEME_START"
            echo "$THEME_CONTENT"
            echo "# THEME_END"
            tail -n +$((insert_line + 3)) "$temp_config"
        } > "${temp_config}.final"
        
        # Replace the original config
        mv "${temp_config}.final" "$GHOSTTY_CONFIG"
        rm -f "$temp_config"
        
        echo "✅ Updated Ghostty configuration with $NEW_THEME theme"
    else
        echo "❌ Could not find theme section in config"
        rm -f "$temp_config"
        return 1
    fi
}

# Update Ghostty theme
update_ghostty_theme

# Reload Ghostty
if pgrep ghostty >/dev/null 2>&1; then
    echo "🔄 Reloading Ghostty..."
    
    # Method 1: Try using AppleScript to send the reload keystroke
    if osascript -e 'tell application "System Events" to tell process "ghostty" to keystroke "," using {command down, shift down}' 2>/dev/null; then
        echo "✅ Sent reload command to Ghostty via AppleScript"
    else
        # Method 2: Try SIGUSR1
        if killall -USR1 ghostty 2>/dev/null; then
            echo "✅ Sent reload signal to Ghostty"
        else
            echo "⚠️  Please press Cmd+Shift+, in Ghostty to reload manually"
        fi
    fi
else
    echo "ℹ️  Ghostty is not running. Theme will apply when you start it."
fi

# For WezTerm - trigger reload
touch "$HOME/.config/wezterm/wezterm.lua"

echo ""
echo "🎨 Theme switching complete!"
echo "   • WezTerm: $NEW_THEME theme active (applies to new windows)"
echo "   • Ghostty: $NEW_THEME theme active"
echo ""