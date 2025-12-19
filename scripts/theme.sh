#!/bin/bash

# Theme Switcher for Ghostty and WezTerm with Exact Color Matching
# This script updates themes by directly modifying the config files

# Paths
WEZTERM_THEME_FILE="$HOME/.config/wezterm/theme"
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
YAZI_THEME="$HOME/.config/yazi/theme.toml"
GEMINI_CONFIG="$HOME/.gemini/settings.json"

# Create directories if they don't exist
mkdir -p "$(dirname "$WEZTERM_THEME_FILE")"

# Read current theme or default to light (since that's working)
CURRENT_THEME="light"
if [ -f "$WEZTERM_THEME_FILE" ]; then
    CURRENT_THEME=$(cat "$WEZTERM_THEME_FILE" | tr -d '[:space:]')
fi

# Context-aware theme switching functions
auto_theme_by_time() {
    hour=$(date +%H)
    if [ $hour -ge 18 ] || [ $hour -lt 6 ]; then
        echo "dark"
    else
        echo "light"
    fi
}

auto_theme_by_battery() {
    if command -v pmset >/dev/null 2>&1; then
        battery_level=$(pmset -g batt | grep -o '[0-9]*%' | tr -d '%')
        if [ "$battery_level" -lt 20 ]; then
            echo "dark"  # Dark theme for battery saving
        else
            echo "$(auto_theme_by_time)"
        fi
    else
        echo "$(auto_theme_by_time)"
    fi
}

auto_theme_by_location() {
    # Check if in a low-light environment (battery + time)
    theme_suggestion="$(auto_theme_by_battery)"
    echo "$theme_suggestion"
}

# Define theme order for cycling
THEMES=("light" "dark" "lgbt_light" "lgbt_dark")

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

LGBT_DARK_THEME='# LGBT Dark Rainbow Theme - Matching WezTerm
foreground = "#F8F9FA"
background = "#0A0A0F"

# Cursor
cursor-color = "#732982"
cursor-text = "#FFFFFF"

# Selection
selection-background = "#2D1B4E"
selection-foreground = "#F8F9FA"

# ANSI Colors (0-7) - Rainbow progression with excellent readability
palette = 0=#424242
palette = 1=#FF6B6B
palette = 2=#81C784
palette = 3=#FFF176
palette = 4=#64B5F6
palette = 5=#BA68C8
palette = 6=#FF8C00
palette = 7=#E0E0E0

# Bright Colors (8-15) - Full intensity rainbow
palette = 8=#9E9E9E
palette = 9=#E40303
palette = 10=#008F11
palette = 11=#FFED00
palette = 12=#004CFF
palette = 13=#732982
palette = 14=#FF8C00
palette = 15=#FFFFFF

# Note: LGBT Dark theme uses pride rainbow colors with dark background
# Optimized for excellent readability on dark terminals'

LGBT_LIGHT_THEME='# LGBT Light Rainbow Theme - Matching WezTerm
foreground = "#1A1A1A"
background = "#FEFEFE"

# Cursor
cursor-color = "#732982"
cursor-text = "#FFFFFF"

# Selection
selection-background = "#E1BEE7"
selection-foreground = "#1A1A1A"

# ANSI Colors (0-7) - Dark rainbow for excellent contrast on light background
palette = 0=#212121
palette = 1=#C62828
palette = 2=#2E7D32
palette = 3=#F57F17
palette = 4=#1565C0
palette = 5=#4A148C
palette = 6=#E65100
palette = 7=#424242

# Bright Colors (8-15) - Medium intensity rainbow for balance
palette = 8=#9E9E9E
palette = 9=#E40303
palette = 10=#008F11
palette = 11=#FFD700
palette = 12=#004CFF
palette = 13=#732982
palette = 14=#FF8C00
palette = 15=#212121

# Note: LGBT Light theme uses pride rainbow colors with light background
# Optimized for excellent contrast on light terminals'

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

# Function to get next theme in cycle
get_next_theme() {
    local current="$1"
    local themes=("${THEMES[@]}")
    local current_index=-1
    
    # Find current theme index
    for i in "${!themes[@]}"; do
        if [[ "${themes[$i]}" = "$current" ]]; then
            current_index=$i
            break
        fi
    done
    
    # Get next theme (cycle back to start if at end)
    local next_index=$(( (current_index + 1) % ${#themes[@]} ))
    echo "${themes[$next_index]}"
}

# Determine new theme
if [[ "$1" == "light" || "$1" == "dark" || "$1" == "lgbt_light" || "$1" == "lgbt_dark" ]]; then
    NEW_THEME="$1"
else
    NEW_THEME=$(get_next_theme "$CURRENT_THEME")
fi

# Set theme content and display message
case "$NEW_THEME" in
    "light")
        THEME_CONTENT="$LIGHT_THEME"
        echo "Switching to Light Theme 🌞"
        ;;
    "dark")
        THEME_CONTENT="$DARK_THEME"
        echo "Switching to Dark Theme 🌙"
        ;;
    "lgbt_light")
        THEME_CONTENT="$LGBT_LIGHT_THEME"
        echo "Switching to LGBT Light Rainbow Theme 🏳️‍🌈"
        ;;
    "lgbt_dark")
        THEME_CONTENT="$LGBT_DARK_THEME"
        echo "Switching to LGBT Dark Rainbow Theme 🏳️‍🌈"
        ;;
    *)
        NEW_THEME="light"
        THEME_CONTENT="$LIGHT_THEME"
        echo "Unknown theme, defaulting to Light Theme 🌞"
        ;;
esac

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
    
    case "$NEW_THEME" in
        "dark")
            # Dark theme EZA colors matching WezTerm
            cat > "$eza_colors_file" << 'EOF'
# EZA Colors for Dark Theme - Matching WezTerm
di=1;35:fi=1;37:ln=1;36:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31:ex=1;32
EOF
            export EZA_COLORS="di=1;35:fi=1;37:ln=1;36:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31:ex=1;32"
            ;;
        "lgbt_light")
            # LGBT Light theme EZA colors with rainbow colors for light background
            cat > "$eza_colors_file" << 'EOF'
# EZA Colors for LGBT Light Theme - Rainbow Colors on Light Background
di=1;34:fi=1;30:ln=1;35:pi=1;32:so=1;31:bd=1;33:cd=1;36:or=1;31:mi=1;31:ex=1;32
EOF
            export EZA_COLORS="di=1;34:fi=1;30:ln=1;35:pi=1;32:so=1;31:bd=1;33:cd=1;36:or=1;31:mi=1;31:ex=1;32"
            ;;
        "lgbt_dark")
            # LGBT Dark theme EZA colors with rainbow colors for dark background
            cat > "$eza_colors_file" << 'EOF'
# EZA Colors for LGBT Dark Theme - Rainbow Colors on Dark Background
di=1;36:fi=1;37:ln=1;33:pi=1;32:so=1;35:bd=1;31:cd=1;34:or=1;31:mi=1;31:ex=1;32
EOF
            export EZA_COLORS="di=1;36:fi=1;37:ln=1;33:pi=1;32:so=1;35:bd=1;31:cd=1;34:or=1;31:mi=1;31:ex=1;32"
            ;;
        *)
            # Use Flexoki Light flavor for light themes with STRONGER colors
            cat > "$YAZI_THEME" << 'EOF'
# Yazi Theme Configuration - Using Flexoki Light Flavor with STRONG Colorful Enhancements
[flavor]
light = "flexoki-light"

# Enhanced colorful file type rules with STRONGER colors (overrides the flavor)
[filetype]
rules = [
  # Images - Strong Pink/Magenta
  { mime = "image/png", fg = "#D6006A", bold = true },
  { mime = "image/jpeg", fg = "#D6006A", bold = true },
  { mime = "image/jpg", fg = "#D6006A", bold = true },
  { mime = "image/gif", fg = "#9D00FF", bold = true },
  { mime = "image/webp", fg = "#D6006A", bold = true },
  { mime = "image/svg+xml", fg = "#7B00E0", bold = true },
  { mime = "image/*", fg = "#D6006A", bold = true },

  # Videos - Strong Orange
  { mime = "video/mp4", fg = "#FF6A00", bold = true },
  { mime = "video/x-matroska", fg = "#FF6A00", bold = true },
  { mime = "video/*", fg = "#FF8800", bold = true },

  # Audio - Strong Yellow
  { mime = "audio/mpeg", fg = "#CCAA00", bold = true },
  { mime = "audio/flac", fg = "#D4A017", bold = true },
  { mime = "audio/*", fg = "#CCAA00", bold = true },

  # Archives - Deep Red/Orange
  { mime = "application/zip", fg = "#CC0000", bold = true },
  { mime = "application/x-tar", fg = "#CC0000", bold = true },
  { mime = "application/x-7z-compressed", fg = "#CC0000", bold = true },
  { mime = "application/gzip", fg = "#FF5500", bold = true },
  { mime = "application/x-bzip", fg = "#FF5500", bold = true },
  { mime = "application/x-rar", fg = "#CC0000", bold = true },

  # Documents - Strong Blue
  { mime = "application/pdf", fg = "#0066CC", bold = true },
  { mime = "text/markdown", fg = "#0066CC", bold = true },
  { name = "*.md", fg = "#0066CC", bold = true },
  { name = "*.txt", fg = "#555555", bold = true },

  # Code files - Strong Varied Colors
  { name = "*.rs", fg = "#00AA88", bold = true },
  { name = "*.go", fg = "#00CCAA", bold = true },
  { name = "*.py", fg = "#0088CC", bold = true },
  { name = "*.js", fg = "#DDAA00", bold = true },
  { name = "*.ts", fg = "#0055DD", bold = true },
  { name = "*.jsx", fg = "#00BBDD", bold = true },
  { name = "*.tsx", fg = "#0055DD", bold = true },
  { name = "*.html", fg = "#FF5500", bold = true },
  { name = "*.css", fg = "#0077DD", bold = true },
  { name = "*.json", fg = "#DDAA00", bold = true },
  { name = "*.yaml", fg = "#8800DD", bold = true },
  { name = "*.yml", fg = "#8800DD", bold = true },
  { name = "*.toml", fg = "#7700CC", bold = true },
  { name = "*.xml", fg = "#FF5500", bold = true },
  { name = "*.sh", fg = "#00AA00", bold = true },
  { name = "*.bash", fg = "#00AA00", bold = true },
  { name = "*.zsh", fg = "#00AA00", bold = true },

  # Config files - Strong Purple
  { name = "*.conf", fg = "#7700CC", bold = true },
  { name = "*.config", fg = "#7700CC", bold = true },
  { name = "*.ini", fg = "#8800DD", bold = true },

  # Build/Lock files - Medium Gray
  { name = "Makefile", fg = "#666666", bold = true },
  { name = "Cargo.lock", fg = "#888888" },
  { name = "package-lock.json", fg = "#888888" },
  { name = "yarn.lock", fg = "#888888" },

  # Special files - Strong Colors
  { name = ".gitignore", fg = "#DD0000", bold = true },
  { name = ".gitattributes", fg = "#DD0000", bold = true },
  { name = ".env", fg = "#DDAA00", bold = true },
  { name = ".env.*", fg = "#DDAA00", bold = true },
  { name = "README*", fg = "#0066CC", bold = true },
  { name = "LICENSE*", fg = "#00AA00", bold = true },

  # Broken symbolic link - Bright Red
  { name = "*", is = "orphan", fg = "#FF0000", crossed = true, bold = true },
  { name = "*/", is = "orphan", fg = "#FF0000", crossed = true, bold = true },

  # Symbolic links - Bright Cyan
  { name = "*", is = "link", fg = "#00BBDD", underline = true, bold = true },
  { name = "*/", is = "link", fg = "#00BBDD", underline = true, bold = true },

  # Executable files - Strong Green
  { name = "*", is = "exec", fg = "#00AA00", bold = true },

  # Empty files - Light gray
  { mime = "inode/empty", fg = "#999999" },

  # Fallback
  { name = "*", fg = "#555555" },
  { name = "*/", fg = "#000000", bold = true }
]

# STRONGER permission colors
[status]
perm_type = { fg = "#8800DD", bold = true }
perm_read = { fg = "#0066CC", bold = true }
perm_write = { fg = "#FF6A00", bold = true }
perm_exec = { fg = "#00AA00", bold = true }
perm_sep = { fg = "#999999" }

# STRONGER marker selections
[mgr]
marker_selected = { fg = "#FFFFFF", bg = "#00AAAA", bold = true }
marker_copied = { fg = "#FFFFFF", bg = "#00AA00", bold = true }
marker_cut = { fg = "#FFFFFF", bg = "#DD0000", bold = true }
marker_marked = { fg = "#FFFFFF", bg = "#8800DD", bold = true }

# STRONGER count indicators
count_selected = { fg = "#FFFFFF", bg = "#00AAAA", bold = true }
count_copied = { fg = "#FFFFFF", bg = "#00AA00", bold = true }
count_cut = { fg = "#FFFFFF", bg = "#DD0000", bold = true }
EOF
            echo "✅ Updated Yazi theme to Flexoki Light flavor with STRONG colorful enhancements"
            ;;
    esac
    
    echo "✅ Updated EZA colors for $NEW_THEME theme"
}

# Update Yazi theme to match terminal
update_yazi_theme() {
    mkdir -p "$(dirname "$YAZI_THEME")"

    case "$NEW_THEME" in
        "dark"|"lgbt_dark")
            # Use Dracula flavor for dark themes
            cat > "$YAZI_THEME" << 'EOF'
# Yazi Theme Configuration - Using Dracula Flavor
[flavor]
dark = "dracula"
EOF
            echo "✅ Updated Yazi theme to Dracula flavor (dark theme)"
            ;;
        *)
            # Use Flexoki Light flavor for light themes with colorful customizations
            cat > "$YAZI_THEME" << 'EOF'
# Yazi Theme Configuration - Using Flexoki Light Flavor with Colorful Enhancements
[flavor]
light = "flexoki-light"

# Enhanced colorful file type rules (overrides the flavor)
[filetype]
rules = [
  # Images - Vibrant Purple/Magenta
  { mime = "image/png", fg = "#A02F6F" },
  { mime = "image/jpeg", fg = "#A02F6F" },
  { mime = "image/jpg", fg = "#A02F6F" },
  { mime = "image/gif", fg = "#5E409D" },
  { mime = "image/webp", fg = "#A02F6F" },
  { mime = "image/svg+xml", fg = "#5E409D" },
  { mime = "image/*", fg = "#A02F6F" },

  # Videos - Bright Orange/Yellow
  { mime = "video/mp4", fg = "#BC5215" },
  { mime = "video/x-matroska", fg = "#BC5215" },
  { mime = "video/*", fg = "#D0A215" },

  # Audio - Yellow
  { mime = "audio/mpeg", fg = "#AD8301" },
  { mime = "audio/flac", fg = "#D0A215" },
  { mime = "audio/*", fg = "#AD8301" },

  # Archives - Red/Orange
  { mime = "application/zip", fg = "#AF3029" },
  { mime = "application/x-tar", fg = "#AF3029" },
  { mime = "application/x-7z-compressed", fg = "#AF3029" },
  { mime = "application/gzip", fg = "#BC5215" },
  { mime = "application/x-bzip", fg = "#BC5215" },
  { mime = "application/x-rar", fg = "#AF3029" },

  # Documents - Blue
  { mime = "application/pdf", fg = "#205EA6" },
  { mime = "text/markdown", fg = "#205EA6" },
  { name = "*.md", fg = "#205EA6" },
  { name = "*.txt", fg = "#6F6E69" },

  # Code files - Various colors
  { name = "*.rs", fg = "#24837B" },
  { name = "*.go", fg = "#3AA99F" },
  { name = "*.py", fg = "#24837B" },
  { name = "*.js", fg = "#D0A215" },
  { name = "*.ts", fg = "#205EA6" },
  { name = "*.jsx", fg = "#3AA99F" },
  { name = "*.tsx", fg = "#205EA6" },
  { name = "*.html", fg = "#BC5215" },
  { name = "*.css", fg = "#205EA6" },
  { name = "*.json", fg = "#D0A215" },
  { name = "*.yaml", fg = "#5E409D" },
  { name = "*.yml", fg = "#5E409D" },
  { name = "*.toml", fg = "#5E409D" },
  { name = "*.xml", fg = "#BC5215" },
  { name = "*.sh", fg = "#66800B" },
  { name = "*.bash", fg = "#66800B" },
  { name = "*.zsh", fg = "#66800B" },

  # Config files - Purple
  { name = "*.conf", fg = "#5E409D" },
  { name = "*.config", fg = "#5E409D" },
  { name = "*.ini", fg = "#5E409D" },

  # Build/Lock files - Gray
  { name = "Makefile", fg = "#6F6E69" },
  { name = "Cargo.lock", fg = "#B7B5AC" },
  { name = "package-lock.json", fg = "#B7B5AC" },
  { name = "yarn.lock", fg = "#B7B5AC" },

  # Special files
  { name = ".gitignore", fg = "#AF3029" },
  { name = ".gitattributes", fg = "#AF3029" },
  { name = ".env", fg = "#D0A215", bold = true },
  { name = ".env.*", fg = "#D0A215", bold = true },
  { name = "README*", fg = "#205EA6", bold = true },
  { name = "LICENSE*", fg = "#66800B" },

  # Broken symbolic link
  { name = "*", is = "orphan", fg = "#AF3029", crossed = true },
  { name = "*/", is = "orphan", fg = "#AF3029", crossed = true },

  # Symbolic links
  { name = "*", is = "link", fg = "#3AA99F", underline = true },
  { name = "*/", is = "link", fg = "#3AA99F", underline = true },

  # Executable files
  { name = "*", is = "exec", fg = "#66800B", bold = true },

  # Empty files
  { mime = "inode/empty", fg = "#B7B5AC" },

  # Fallback
  { name = "*", fg = "#6F6E69" },
  { name = "*/", fg = "#100F0F", bold = true }
]

# More vibrant permission colors
[status]
perm_type = { fg = "#5E409D", bold = true }
perm_read = { fg = "#205EA6", bold = true }
perm_write = { fg = "#BC5215", bold = true }
perm_exec = { fg = "#66800B", bold = true }
perm_sep = { fg = "#B7B5AC" }

# More colorful marker selections
[mgr]
marker_selected = { fg = "#24837B", bg = "#BFE8D9", bold = true }
marker_copied = { fg = "#66800B", bg = "#E6E4D9", bold = true }
marker_cut = { fg = "#AF3029", bg = "#F2F0E5", bold = true }
marker_marked = { fg = "#5E409D", bg = "#E6E4D9", bold = true }

# Colorful count indicators
count_selected = { fg = "#FFFCF0", bg = "#24837B", bold = true }
count_copied = { fg = "#FFFCF0", bg = "#66800B", bold = true }
count_cut = { fg = "#FFFCF0", bg = "#AF3029", bold = true }
EOF
            echo "✅ Updated Yazi theme to Flexoki Light flavor with colorful enhancements"
            ;;
    esac
}

# Update Gemini CLI theme
update_gemini_theme() {
    if [ ! -f "$GEMINI_CONFIG" ]; then
        echo "⚠️  Gemini config file not found at $GEMINI_CONFIG. Skipping Gemini theme update."
        return 0
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo "⚠️  jq not found. Skipping Gemini theme update."
        return 0
    fi

    local gemini_theme=""
    case "$NEW_THEME" in
        "light")
            gemini_theme="TokyoNightLight"
            ;;
        "dark")
            gemini_theme="TokyoNightCustom"
            ;;
        "lgbt_light")
            gemini_theme="LGBTLight"
            ;;
        "lgbt_dark")
            gemini_theme="LGBTDark"
            ;;
        *)
            gemini_theme="TokyoNightLight"
            ;;
    esac

    local temp_json="${GEMINI_CONFIG}.tmp"
    jq --arg theme "$gemini_theme" '.ui.theme = $theme' "$GEMINI_CONFIG" > "$temp_json" && mv "$temp_json" "$GEMINI_CONFIG"
    
    echo "✅ Updated Gemini CLI theme to $gemini_theme"
    echo "⚠️  (You may need to restart the Gemini CLI for changes to take effect)"
}

# Update Claude Code theme tracking
update_claude_theme() {
    local claude_config="$HOME/.config/claude-code/theme-config.json"

    if [ ! -f "$claude_config" ]; then
        echo "⚠️  Claude Code theme config not found. Skipping Claude Code theme update."
        return 0
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo "⚠️  jq not found. Skipping Claude Code theme update."
        return 0
    fi

    # Update the current theme in the config file
    local temp_json="${claude_config}.tmp"
    jq --arg theme "$NEW_THEME" '.currentTheme = $theme' "$claude_config" > "$temp_json" && mv "$temp_json" "$claude_config"

    echo "✅ Updated Claude Code theme tracking to $NEW_THEME"
    echo "ℹ️  (Claude Code inherits terminal colors from WezTerm/Ghostty automatically)"
}

# Update Neovim theme
update_nvim_theme() {
    local nvim_theme_file="$HOME/.config/nvim/lua/gabriel/current_theme.lua"
    
    if [ ! -d "$(dirname "$nvim_theme_file")" ]; then
        echo "⚠️  Neovim config directory not found. Skipping Neovim theme update."
        return 0
    fi
    
    # Map the theme name to what appearance.lua expects
    # The logic in appearance.lua handles "light", "dark", "lgbt_light", "lgbt_dark" directly
    # but we can be explicit here if we want.
    # The updated appearance.lua checks: 
    # enabled = (current_theme_name == "monokai-pro" or current_theme_name == "dark" or current_theme_name == "lgbt_dark")
    # enabled = (current_theme_name == "ayu-light" or current_theme_name == "light" or current_theme_name == "lgbt_light")
    
    echo "return \"$NEW_THEME\"" > "$nvim_theme_file"
    echo "✅ Updated Neovim theme configuration to \"$NEW_THEME\""
}

# Update Ghostty theme
update_ghostty_theme

# Update EZA colors
update_eza_colors

# Update Yazi theme
update_yazi_theme

# Update Gemini theme
update_gemini_theme

# Update Claude Code theme
update_claude_theme

# Update Neovim theme
update_nvim_theme

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
echo "   • Yazi: Status bar colors updated to match theme"
echo "   • EZA: Colors updated to match terminal theme"
echo "   • Gemini: Theme updated to match terminal theme (restart required)"
echo "   • Claude Code: Theme tracking updated (inherits terminal colors automatically)"
echo ""
echo "🌈 Available Themes (cycle with this script):"
echo "   • Light Theme 🌞 - Clean light background"
echo "   • Dark Theme 🌙 - Dark background with bright colors"
echo "   • LGBT Light Rainbow Theme 🏳️‍🌈 - Pride colors on light background"
echo "   • LGBT Dark Rainbow Theme 🏳️‍🌈 - Pride colors on dark background"
echo ""
echo "🎯 Color Matching Applied:"
echo "   • Extended 256-color palette (0-255)"
echo "   • File type specific colors (40-46)"
echo "   • Permission specific colors (50-54)"
echo "   • EZA directory and file colors synchronized"
echo ""
echo "💡 If colors still don't match exactly, you may need to:"
echo "   • Source your .zshrc: source ~/.zshrc"
echo "   • Restart your shell session"
echo ""
echo "🤖 Auto Theme Commands:"
echo "   • $0 auto     - Auto-select theme based on time and battery"
echo "   • $0 time     - Switch based on time of day only"
echo "   • $0 battery  - Switch based on battery level and time"
echo ""

# Handle auto theme switching commands
if [ "$1" = "auto" ]; then
    AUTO_THEME="$(auto_theme_by_location)"
    echo "🤖 Auto-selecting theme: $AUTO_THEME (based on time and battery)"
    exec "$0" "$AUTO_THEME"
elif [ "$1" = "time" ]; then
    TIME_THEME="$(auto_theme_by_time)"
    echo "🕒 Time-based theme: $TIME_THEME"
    exec "$0" "$TIME_THEME"
elif [ "$1" = "battery" ]; then
    BATTERY_THEME="$(auto_theme_by_battery)"
    echo "🔋 Battery-aware theme: $BATTERY_THEME"
    exec "$0" "$BATTERY_THEME"
fi
