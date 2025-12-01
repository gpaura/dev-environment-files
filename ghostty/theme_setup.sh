#!/bin/bash
# This creates the missing ghostty-theme file and updates your theme.sh script

# First, let's create the ghostty-theme file that your config expects
echo "Creating ghostty-theme file..."
cat > ~/.config/ghostty/ghostty-theme << 'EOF'
# This file is dynamically updated by the theme switcher
# It will contain either dark-theme.conf or light-theme.conf path

/Users/gabrielpaura/.config/ghostty/dark-theme.conf
EOF

# Now let's update your theme.sh script to handle both WezTerm and Ghostty
echo "Creating updated theme.sh script..."
cat > ~/theme.sh << 'EOF'
#!/bin/bash

WEZTERM_THEME_FILE="$HOME/.config/wezterm/theme"
GHOSTTY_THEME_FILE="$HOME/.config/ghostty/ghostty-theme"
GHOSTTY_CURRENT_THEME_FILE="$HOME/.config/ghostty/current-theme.conf"

# Create directories if they don't exist
mkdir -p "$(dirname "$WEZTERM_THEME_FILE")"
mkdir -p "$(dirname "$GHOSTTY_THEME_FILE")"

# Check current theme from WezTerm file (or create default)
if [ -f "$WEZTERM_THEME_FILE" ] && grep -q "dark" "$WEZTERM_THEME_FILE"; then
    NEW_THEME="light"
    THEME_EMOJI="🌞"
    GHOSTTY_CONFIG_PATH="$HOME/.config/ghostty/light-theme.conf"
else
    NEW_THEME="dark"
    THEME_EMOJI="🌙"
    GHOSTTY_CONFIG_PATH="$HOME/.config/ghostty/dark-theme.conf"
fi

# Update WezTerm theme
echo "$NEW_THEME" > "$WEZTERM_THEME_FILE"

# Update Ghostty theme
echo "$GHOSTTY_CONFIG_PATH" > "$GHOSTTY_THEME_FILE"
echo "$GHOSTTY_CONFIG_PATH" > "$GHOSTTY_CURRENT_THEME_FILE"

echo "Switching to ${NEW_THEME^} Theme $THEME_EMOJI"

# Reload Ghostty
if pgrep ghostty >/dev/null 2>&1; then
    # Try to reload Ghostty configuration
    pkill -USR1 ghostty 2>/dev/null && \
    echo "Ghostty configuration reloaded" || \
    echo "Note: Could not reload Ghostty, theme will apply on next launch"
fi

# For WezTerm, create a touch file that WezTerm can watch for changes
touch "$HOME/.config/wezterm/wezterm.lua"
echo "Theme files updated. Changes will apply to new terminal windows."
EOF

# Make the script executable
chmod +x ~/theme.sh

echo "Setup complete! Your theme switching system is now ready for both WezTerm and Ghostty."
echo ""
echo "Files created/updated:"
echo "  ~/.config/ghostty/ghostty-theme"
echo "  ~/.config/ghostty/current-theme.conf" 
echo "  ~/theme.sh (updated)"
echo ""
echo "Run 'theme' command to switch between light and dark themes!"
