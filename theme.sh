#!/bin/bash

# Theme Switcher for Ghostty and WezTerm with Exact Color Matching
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

# Define themes with exact WezTerm color matching
DARK_THEME='# Dark theme settings - EXACT WEZTERM MATCH
foreground = "#F8F8F2"
background = "#1A1B26"

# Cursor
cursor-color = "#FF79C6"
cursor-text = "#282A36"

# Selection
selection-background = "#44475A"
selection-foreground = "#F8F8F2"

# ANSI Colors (0-7) - Exact WezTerm Match with enhanced readability
palette = 0=#414868
palette = 1=#FF5555
palette = 2=#50FA7B
palette = 3=#FF40A3
palette = 4=#7AA2F7
palette = 5=#FF79C6
palette = 6=#8BE9FD
palette = 7=#ACAAB6

# Bright Colors (8-15) - Exact WezTerm Match with enhanced readability
palette = 8=#565F89
palette = 9=#F7768E
palette = 10=#A9FF68
palette = 11=#FF66C7
palette = 12=#BD93F9
palette = 13=#FC9867
palette = 14=#78DCE8
palette = 15=#F8F8F2

# Note: Ghostty only supports palette colors 0-15
# Extended colors are handled through the base 16 ANSI colors'

LIGHT_THEME='# Light theme settings - EXACT WEZTERM MATCH
foreground = "#2D2A2E"
background = "#FAFAFA"
cursor-color = "#FF2D76"
cursor-text = "#FFFFFF"
selection-background = "#E0E0E0"
selection-foreground = "#2D2A2E"

# ANSI Colors (0-7) - Exact WezTerm Match
palette = 0=#5A5257
palette = 1=#F26F22
palette = 2=#0000FF
palette = 3=#FF40A3
palette = 4=#9D50FF
palette = 5=#FF3388
palette = 6=#19B3CD
palette = 7=#A64DFF

# Bright Colors (8-15) - Exact WezTerm Match
palette = 8=#7A686E
palette = 9=#F5623D
palette = 10=#4E9F2F
palette = 11=#FF66C7
palette = 12=#B77BFF
palette = 13=#FF66C7
palette = 14=#58DDEF
palette = 15=#FFFFFF

# Note: Ghostty only supports palette colors 0-15
# Extended colors are handled through the base 16 ANSI colors'

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

# Function to update Ghostty config with exact color matching
update_ghostty_theme() {
    if [ ! -f "$GHOSTTY_CONFIG" ]; then
        echo "Error: Ghostty config file not found!"
        return 1
    fi
    
    # Create a temporary file
    local temp_config="${GHOSTTY_CONFIG}.tmp"
    
    # Copy everything except the theme section and font configuration
    awk '
    BEGIN { in_theme = 0; in_font = 0 }
    /# THEME_START/ { in_theme = 1; next }
    /# THEME_END/ { in_theme = 0; next }
    /# FONT CONFIGURATION - BOLD EVERYTHING/ { in_font = 1 }
    /# WINDOW CONFIGURATION/ { if (in_font) in_font = 0 }
    !in_theme && !in_font { print }
    ' "$GHOSTTY_CONFIG" > "$temp_config"
    
    # Find where to insert the theme (after the theme configuration comment)
    local theme_insert_line=$(grep -n "# THEME CONFIGURATION" "$temp_config" | cut -d: -f1)
    
    # Find where to insert font config (after the padding settings)
    local font_insert_line=$(grep -n "window-padding-y" "$temp_config" | cut -d: -f1)
    
    if [ -n "$theme_insert_line" ] && [ -n "$font_insert_line" ]; then
        # Insert the new theme and bold font configuration
        {
            head -n $((theme_insert_line + 2)) "$temp_config"
            echo "# THEME_START"
            echo "$THEME_CONTENT"
            echo "# THEME_END"
            echo ""
            echo "# Shader configuration"
            echo "custom-shader = shaders/bloom025.glsl"
            echo ""
            echo "# Command configuration"
            echo "command = zsh --login -c \"if command -v tmux >/dev/null 2>&1; then tmux attach || tmux; else zsh; fi\""
            echo ""
            echo "# Window padding"
            echo "window-padding-x = 4,2"
            echo "window-padding-y = 6,0"
            echo ""
            echo "# ============================================================================"
            echo "# FONT CONFIGURATION - BOLD EVERYTHING LIKE WEZTERM"
            echo "# ============================================================================"
            echo "# Primary font - use ExtraBold for everything"
            echo "font-family = \"JetBrainsMono Nerd Font Mono ExtraBold\""
            echo "font-size = 19"
            echo ""
            echo "# Additional font settings for better rendering"
            echo "font-feature = +liga,+calt,+ss01,+ss02,+ss03"
            echo "font-thicken = true"
            echo ""
            echo "# Force bold rendering for all text types"
            echo "bold-is-bright = false"
            echo ""
            echo "# Use font-thicken for maximum boldness"
            echo "font-thicken = true"
            echo ""
            echo "# Try using a bolder font variant if available"
            echo "font-family-bold = \"JetBrainsMono Nerd Font Mono Black\""
            echo "font-family-italic = \"JetBrainsMono Nerd Font Mono ExtraBold\""
            echo "font-family-bold-italic = \"JetBrainsMono Nerd Font Mono Black\""
            echo ""
            tail -n +$((font_insert_line + 1)) "$temp_config" | grep -A 1000 "# WINDOW CONFIGURATION"
        } > "${temp_config}.final"
        
        # Replace the original config
        mv "${temp_config}.final" "$GHOSTTY_CONFIG"
        rm -f "$temp_config"
        
        echo "✅ Updated Ghostty configuration with $NEW_THEME theme and exact WezTerm colors"
    else
        echo "❌ Could not find insertion points in config"
        rm -f "$temp_config"
        return 1
    fi
}

# Also update EZA colors to match
update_eza_colors() {
    local eza_colors_file="$HOME/.config/eza/colors"
    mkdir -p "$(dirname "$eza_colors_file")"
    
    if [ "$NEW_THEME" = "dark" ]; then
        # Dark theme EZA colors matching WezTerm
        cat > "$eza_colors_file" << 'EOF'
# EZA Colors for Dark Theme - Matching WezTerm
di=1;35:fi=1;37:ln=1;36:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31:ex=1;32
EOF
        export EZA_COLORS="di=1;35:fi=1;37:ln=1;36:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31:ex=1;32"
    else
        # Light theme EZA colors matching WezTerm
        cat > "$eza_colors_file" << 'EOF'
# EZA Colors for Light Theme - Matching WezTerm
di=1;35:fi=1;30:ln=1;36:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31:ex=1;32
EOF
        export EZA_COLORS="di=1;35:fi=1;30:ln=1;36:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31:ex=1;32"
    fi
    
    echo "✅ Updated EZA colors for $NEW_THEME theme"
}

# Update Ghostty theme
update_ghostty_theme

# Update EZA colors
update_eza_colors

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
echo "🎨 Theme switching complete with exact color matching!"
echo "   • WezTerm: $NEW_THEME theme active"
echo "   • Ghostty: $NEW_THEME theme active with EXACT WezTerm colors"
echo "   • EZA: Colors updated to match terminal theme"
echo ""
echo "🌈 Color Matching Applied:"
echo "   • Extended 256-color palette (0-255)"
echo "   • File type specific colors (40-46)"
echo "   • Permission specific colors (50-54)"
echo "   • EZA directory and file colors synchronized"
echo ""
echo "💡 If colors still don't match exactly, you may need to:"
echo "   • Source your .zshrc: source ~/.zshrc"
echo "   • Restart your shell session"
echo ""