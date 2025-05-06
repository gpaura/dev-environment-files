# Add this to your config.nu file to fix invisible borders in light theme

# Function to read the theme from the theme file
def get-current-theme [] {
    let theme_file = ($env.HOME | path join ".config" "wezterm" "theme")
    if ($theme_file | path exists) {
        let theme_content = (open $theme_file | str trim)
        if $theme_content == "dark" { "dark" } else { "light" }
    } else {
        "dark"  # Default to dark theme if file doesn't exist
    }
}

# Dark theme colors (based on your WezTerm dark theme)
let dark_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    bool: light_cyan
    int: white
    filesize: cyan
    duration: white
    date: purple
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cell-path: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: { bg: red fg: white }
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    shape_garbage: { fg: white bg: red attr: b}
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
}

# Light theme with extreme contrast for better visibility
let light_theme_extreme = {
    # Basic colors with high contrast
    separator: "#0000FF"                  # Pure blue
    leading_trailing_space_bg: { attr: n }
    header: "#0000FF"                    # Pure blue with bold
    empty: "#0000FF"                     # Pure blue
    bool: "#9400D3"                      # Dark violet
    int: "#000000"                       # Black
    filesize: "#0000FF"                  # Pure blue
    duration: "#000000"                  # Black
    date: "#9400D3"                      # Dark violet
    range: "#000000"                     # Black
    float: "#000000"                     # Black
    string: "#000000"                    # Black
    nothing: "#000000"                   # Black
    binary: "#000000"                    # Black
    cell-path: "#0000FF"                 # Pure blue
    row_index: "#0000FF"                 # Pure blue
    record: "#000000"                    # Black
    list: "#000000"                      # Black
    block: "#000000"                     # Black
    hints: "#0000FF"                     # Pure blue
    search_result: { fg: white bg: red }
    
    # Shape elements with high contrast
    shape_and: "#9400D3"                 # Dark violet
    shape_binary: "#9400D3"              # Dark violet
    shape_block: "#0000FF"               # Pure blue
    shape_bool: "#9400D3"                # Dark violet
    shape_closure: "#006400"             # Dark green
    shape_custom: "#006400"              # Dark green
    shape_datetime: "#0000FF"            # Pure blue
    shape_directory: "#0000FF"           # Pure blue
    shape_external: "#0000FF"            # Pure blue
    shape_externalarg: "#006400"         # Dark green
    shape_external_resolved: "#9400D3"   # Dark violet
    shape_filepath: "#0000FF"            # Pure blue
    shape_flag: "#0000FF"                # Pure blue
    shape_float: "#9400D3"               # Dark violet
    shape_garbage: { fg: white bg: red attr: b}
    shape_glob_interpolation: "#0000FF"  # Pure blue
    shape_globpattern: "#0000FF"         # Pure blue
    shape_int: "#9400D3"                 # Dark violet
    shape_internalcall: "#0000FF"        # Pure blue
    shape_keyword: "#0000FF"             # Pure blue
    shape_list: "#0000FF"                # Pure blue
    shape_literal: "#0000FF"             # Pure blue
    shape_match_pattern: "#006400"       # Dark green
    shape_matching_brackets: { fg: "#9400D3" bg: "#D0D0D0" attr: "bu" }  # Dark violet on light gray, bold+underlined
    shape_nothing: "#9400D3"             # Dark violet
    shape_operator: "#000000"            # Black
    shape_or: "#9400D3"                  # Dark violet
    shape_pipe: "#9400D3"                # Dark violet
    shape_range: "#000000"               # Black
    shape_record: "#0000FF"              # Pure blue
    shape_redirection: "#9400D3"         # Dark violet
    shape_signature: "#006400"           # Dark green
    shape_string: "#006400"              # Dark green
    shape_string_interpolation: "#0000FF" # Pure blue
    shape_table: "#0000FF"               # Pure blue
    shape_variable: "#9400D3"            # Dark violet
    shape_vardecl: "#9400D3"             # Dark violet
    shape_raw_string: "#9400D3"          # Dark violet
    shape_type: "#FF0000"                # Pure red for type indicators
}

# Create extremly visible ASCII borders for tables
def set-extreme-borders [] {
    # Use basic mode with ASCII characters
    $env.config = ($env.config | upsert table.mode "basic")
    
    # Pure red for maximum contrast on light backgrounds
    $env.config = ($env.config | upsert table.border_color "#FF0000")
    
    # Use solid ASCII box-drawing characters
    $env.config = ($env.config | upsert table.corner_top_left "+")
    $env.config = ($env.config | upsert table.corner_top_right "+")
    $env.config = ($env.config | upsert table.corner_bottom_left "+")
    $env.config = ($env.config | upsert table.corner_bottom_right "+")
    $env.config = ($env.config | upsert table.edge_left "|")
    $env.config = ($env.config | upsert table.edge_right "|")
    $env.config = ($env.config | upsert table.edge_top "-")
    $env.config = ($env.config | upsert table.edge_bottom "-")
    $env.config = ($env.config | upsert table.edge_top_intersection "+")
    $env.config = ($env.config | upsert table.edge_bottom_intersection "+")
    $env.config = ($env.config | upsert table.edge_vertical_intersection "+")
    $env.config = ($env.config | upsert table.cell_horizontal "-")
    $env.config = ($env.config | upsert table.cell_vertical "|")
    $env.config = ($env.config | upsert table.cell_intersection "+")
    
    # Increase padding for better readability
    $env.config = ($env.config | upsert table.padding 2)
    
    # Make sure header stands out
    $env.config = ($env.config | upsert table.header_color "#FF0000")
    $env.config = ($env.config | upsert table.header_style "bold")
}

# Apply the correct theme based on the theme file
def-env update-nushell-theme [] {
    let current_theme = (get-current-theme)
    
    if $current_theme == "dark" {
        # Set dark theme
        $env.config = ($env.config | upsert color_config $dark_theme)
        
        # Dark theme table settings
        $env.config = ($env.config | upsert table.mode "rounded")
        $env.config = ($env.config | upsert table.border_color $dark_theme.separator)
    } else {
        # Set extreme contrast light theme
        $env.config = ($env.config | upsert color_config $light_theme_extreme)
        
        # Apply extreme contrast borders
        set-extreme-borders
    }
    
    # Return nothing to avoid polluting output
    null
}

# Create a command to immediately apply extreme contrast light theme
def fix-light-theme [] {
    # Force extreme contrast light theme
    $env.config = ($env.config | upsert color_config $light_theme_extreme)
    
    # Apply extreme contrast borders
    set-extreme-borders
    
    # Let the user know
    echo "Applied extreme contrast light theme with highly visible borders"
}

# Create a command to diagnose display issues
def diagnose-table-display [] {
    echo "Current theme:" (get-current-theme)
    echo ""
    echo "Table settings:"
    $env.config | get table | to md
    echo ""
    echo "Table border:" ($env.config | get table.border_color)
    echo "Table mode:" ($env.config | get table.mode)
    echo ""
    echo "Critical color values:"
    echo "  Separator: " ($env.config.color_config | get separator)
    echo "  Filepath: " ($env.config.color_config | get shape_filepath)
    echo "  Type: " ($env.config.color_config | get -i shape_type)
    
    # Test output with forced colors
    echo ""
    echo "Test output with forced colors:"
    [[name, value]; ['test_file.txt', '123']] | table
}

# Add this to your config.nu's env_change hook to update when directory changes
# This helps catch theme changes when you run your theme.sh script
$env.config.hooks.env_change.PWD = [
    {|before, after| update-nushell-theme }
]

# Command to manually toggle theme from within Nushell
def toggle-theme [] {
    let theme_file = ($env.HOME | path join ".config" "wezterm" "theme")
    let current_theme = (if ($theme_file | path exists) {
        open $theme_file | str trim
    } else {
        "dark"
    })
    
    let new_theme = (if $current_theme == "dark" { "light" } else { "dark" })
    $new_theme | save -f $theme_file
    
    # Update terminal if applicable
    ^touch ~/.config/wezterm/wezterm.lua
    
    # Update Nushell theme
    update-nushell-theme
    
    echo $"Switched to ($new_theme) theme 🎨"
}

# Run this at startup to apply the theme
update-nushell-theme

# Apply extreme contrast immediately if we're in light theme
if (get-current-theme) == "light" {
    fix-light-theme
}
