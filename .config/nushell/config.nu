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

# Light theme colors with enhanced visibility for borders and UI elements
let light_theme = {
    # color for nushell primitives
    separator: black  # Change to black for better visibility
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: blue_bold  # Use blue_bold instead of green_bold
    empty: blue
    bool: dark_cyan
    int: black  # Change to black for better visibility
    filesize: cyan_bold
    duration: black  # Change to black for better visibility
    date: purple
    range: black  # Change to black for better visibility
    float: black  # Change to black for better visibility
    string: black  # Change to black for better visibility
    nothing: black  # Change to black for better visibility
    binary: black  # Change to black for better visibility
    cell-path: black  # Change to black for better visibility
    row_index: blue_bold  # Change to blue_bold for better visibility
    record: black  # Change to black for better visibility
    list: black  # Change to black for better visibility
    block: black  # Change to black for better visibility
    hints: black  # Change to black for better visibility
    search_result: { fg: white bg: red }
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
    shape_external_resolved: purple_bold  # Change to purple_bold for better visibility
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
    shape_matching_brackets: { fg: purple bg: light_gray attr: u }  # Add background for better visibility
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

# Apply the correct theme based on the theme file
def-env update-nushell-theme [] {
    let current_theme = (get-current-theme)
    let config_colors = if $current_theme == "dark" { $dark_theme } else { $light_theme }
    
    # Set the color config
    $env.config = ($env.config | upsert color_config $config_colors)
    
    # Change table mode based on theme for better visibility
    if $current_theme == "dark" {
        # Dark theme can use rounded borders
        $env.config = ($env.config | upsert table.mode "rounded")
    } else {
        # Light theme needs heavier borders for visibility
        # Options: "heavy", "double", "thick", "reinforced"
        $env.config = ($env.config | upsert table.mode "heavy")
    }
    
    # Return nothing to avoid polluting output
    null
}

# Add this to your config.nu's env_change hook to update when directory changes
# This helps catch theme changes when you run your theme.sh script
$env.config.hooks.env_change.PWD = [
    {|before, after| update-nushell-theme }
]

# Run this at startup to apply the theme
update-nushell-theme

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
