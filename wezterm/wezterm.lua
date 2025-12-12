
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Tmux
-- config.term = "wezterm"
config.enable_kitty_graphics = true

config.automatically_reload_config = true

config.window_close_confirmation = "NeverPrompt"
config.quit_when_all_windows_are_closed = true

-- Remove or comment out initial_cols/rows if using this method
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})

  -- Set exact size in pixels
  local window_width = 2100  -- Adjust this
  local window_height = 1350 -- Adjust this

  -- Center on screen
  local screen = wezterm.gui.screens().active
  local x = (screen.width - window_width) / 2
  local y = (screen.height - window_height) / 2

  window:gui_window():set_inner_size(window_width, window_height)
  window:gui_window():set_position(x, y)

  -- Keep window on top
  window:gui_window():set_level("AlwaysOnTop")
end)

-- Function to read the theme from a file
local function read_theme()
  local success, file = pcall(io.open, os.getenv("HOME") .. "/.config/wezterm/theme", "r")
  if success and file then
    local theme = file:read("*all")
    file:close()
    return theme:gsub("%s+", "") -- Trim whitespace
  else
    return "dark" -- Default to dark theme
  end
end

-- LGBT Pride Rainbow Colors and Extended Palette
local rainbow_extended = {
  -- Core pride colors
  pride_red = "#E40303",
  pride_orange = "#FF8C00", 
  pride_yellow = "#FFED00",
  pride_green = "#008F11",
  pride_blue = "#004CFF",
  pride_purple = "#732982",
  
  -- Lighter variants for dark theme
  light_red = "#FF6B6B",
  light_orange = "#FFB347",
  light_yellow = "#FFF176",
  light_green = "#81C784",
  light_blue = "#64B5F6",
  light_purple = "#BA68C8",
  
  -- Darker variants for light theme
  dark_red = "#C62828",
  dark_orange = "#E65100",
  dark_yellow = "#F57F17",
  dark_green = "#2E7D32", 
  dark_blue = "#1565C0",
  dark_purple = "#4A148C",
  
  -- Neutral colors
  bright_white = "#FFFFFF",
  soft_white = "#F8F9FA",
  light_gray = "#E0E0E0",
  medium_gray = "#9E9E9E",
  dark_gray = "#424242",
  soft_black = "#212121",
  deep_black = "#000000"
}

-- Define the pink color for status information (RGB: close to pink 198)
local STATUS_PINK = "#FF40A3"

-- Define Dark Theme (your existing theme)
local dark_theme = {
  -- Base colors
  foreground = "#F8F8F2", -- Bright off-white from Dracula for text
  background = "#1A1B26", -- Deep blue-black from Tokyo Night

  -- Cursor
  cursor_bg = "#FF79C6",     -- Bright pink from Dracula
  cursor_border = "#FF79C6", -- Matching border
  cursor_fg = "#282A36",     -- Dark background from Dracula for text under cursor

  -- Selection
  selection_bg = "#44475A", -- Dracula selection color
  selection_fg = "#F8F8F2", -- Same as foreground

  -- ANSI Colors (0-7) - Rich and vibrant fusion
  ansi = {
    "#414868",   -- Black (0): Tokyo Night dark blue-gray
    "#FF5555",   -- Red (1): Dracula red
    "#50FA7B",   -- Green (2): Dracula green
    STATUS_PINK, -- Yellow (3): Changed to pink (was Monokai Pro yellow)
    "#7AA2F7",   -- Blue (4): Tokyo Night blue
    "#FF79C6",   -- Magenta (5): Dracula pink
    "#8BE9FD",   -- Cyan (6): Dracula cyan
    "#ACAAB6",   -- White (7): Light gray based on Tokyo Night
  },

  -- Bright Colors (8-15) - Vivid and complementary
  brights = {
    "#565F89", -- Bright Black (8): Tokyo Night lighter blue-gray
    "#F7768E", -- Bright Red (9): Tokyo Night salmon
    "#A9FF68", -- Bright Green (10): Brighter green (Dracula-inspired)
    "#FF66C7", -- Bright Yellow (11): Changed to a different pink (was Monokai Pro gold)
    "#BD93F9", -- Bright Blue (12): Dracula purple
    "#FC9867", -- Bright Magenta (13): Monokai Pro orange
    "#78DCE8", -- Bright Cyan (14): Monokai Pro light blue
    "#F8F8F2", -- Bright White (15): Dracula foreground
  },

  -- Indexed colors for special highlighting
  indexed = {
    [16] = "#FFB86C", -- Dracula orange
    [17] = "#FF9E64", -- Tokyo Night orange
    [18] = "#BB9AF7", -- Tokyo Night purple
    [19] = "#FC9867", -- Monokai Pro orange
    [20] = "#FF79C6", -- Dracula pink
    [21] = "#AB9DF2", -- Monokai Pro purple
    [22] = "#FF75A0", -- Custom bright pink
    [23] = "#9ECE6A", -- Tokyo Night green
    [24] = "#7DCFFF", -- Tokyo Night light blue
    [25] = "#73DACA", -- Tokyo Night aqua
  },

  -- Tab bar colors
  tab_bar = {
    background = "#1A1B26",
    active_tab = {
      bg_color = "#414868",
      fg_color = "#F8F8F2",
    },
    inactive_tab = {
      bg_color = "#1A1B26",
      fg_color = "#565F89",
    },
    inactive_tab_hover = {
      bg_color = "#24283B",
      fg_color = "#F8F8F2",
    },
    new_tab = {
      bg_color = "#1A1B26",
      fg_color = "#565F89",
    },
    new_tab_hover = {
      bg_color = "#24283B",
      fg_color = "#F8F8F2",
    },
  },
}

-- Define Light Theme (your existing theme)
local light_theme = {
  -- Base colors
  foreground = "#2D2A2E", -- Darker gray for better contrast on light background
  background = "#FAFAFA", -- Keeping the same clean off-white

  -- Cursor
  cursor_bg = "#FF2D76",     -- More intense pink cursor
  cursor_border = "#FF2D76", -- Matching border
  cursor_fg = "#FFFFFF",     -- White text under cursor

  -- Selection
  selection_bg = "#E0E0E0", -- Slightly darker selection for better visibility
  selection_fg = "#2D2A2E", -- Same as foreground

  -- ANSI Colors (0-7)
  ansi = {
    "#5A5257", -- Black (0): Darker purple-gray for better visibility
    "#F26F22", --#AA7800", --"#FF0F60",
    "#0000FF", -- Bright Blue
    STATUS_PINK,
    "#9D50FF", -- Blue (4): Intensified purple
    "#FF3388", -- Magenta (5): Stronger pink
    "#19B3CD", -- Cyan (6): Deeper blue
    "#A64DFF", --"#FF9000", --"#50FA7B", --"#AA7800", --"#F8F8F2", -- White (7): Slightly off-white
  },

  -- Bright Colors (8-15) - Strengthened with darker yellow and green
  brights = {
    "#7A686E", -- Bright Black (8): Darker for better visibility
    "#F5623D", -- Bright Red (9): Deeper orange-red
    "#4E9F2F", -- Bright Green (10): Olive green tone for better visibility
    "#FF66C7", -- Bright Yellow (11): Changed to pink (was darker yellow)
    "#B77BFF", -- Bright Blue (12): Stronger light purple
    "#FF66C7", -- Bright Magenta (13): Stronger pink
    "#58DDEF", -- Bright Cyan (14): More vibrant cyan
    "#FFFFFF", -- Bright White (15): Pure white
  },

  -- Indexed colors - Strengthened
  indexed = {
    [16] = "#FF9000", -- Stronger orange
    [17] = "#C49E3F", -- C49E3F Darker, more visible gold
    [18] = "#AA7800", -- Much darker gold for visibility
    [19] = "#FF42A1", -- More vibrant pink
    [20] = "#A64DFF", -- Stronger purple
    [21] = "#8F95A0", -- 8F95A0 Darker gray for visibility
    [22] = "#845AC7", -- Stronger purple for emphasis
    [23] = "#097CCD", -- Deeper blue
    [24] = "#FF6200", -- Stronger orange
    [25] = "#45C7FF", -- More intense cyan
  },

  -- Tab bar colors - Slightly strengthened
  tab_bar = {
    background = "#E0E0E0", -- Slightly darker for better contrast
    active_tab = {
      bg_color = "#FAFAFA",
      fg_color = "#2D2A2E", -- Darker text for better visibility
    },
    inactive_tab = {
      bg_color = "#E0E0E0",
      fg_color = "#7A686E", -- Darker text for better visibility
    },
    inactive_tab_hover = {
      bg_color = "#EEEEEE",
      fg_color = "#2D2A2E",
    },
    new_tab = {
      bg_color = "#E0E0E0",
      fg_color = "#7A686E",
    },
    new_tab_hover = {
      bg_color = "#EEEEEE",
      fg_color = "#2D2A2E",
    },
  },
}

-- NEW: LGBT Dark Rainbow Theme
local lgbt_dark_theme = {
  -- Base colors - Dark background with excellent contrast
  foreground = rainbow_extended.soft_white,   -- Soft white text
  background = "#0A0A0F",                     -- Very dark blue-black
  
  -- Cursor - Bright rainbow accent
  cursor_bg = rainbow_extended.pride_purple,
  cursor_border = rainbow_extended.pride_purple,
  cursor_fg = rainbow_extended.bright_white,
  
  -- Selection - Subtle rainbow gradient effect
  selection_bg = "#2D1B4E",  -- Dark purple with transparency feel
  selection_fg = rainbow_extended.soft_white,
  
  -- ANSI Colors (0-7) - Rainbow progression with excellent readability
  ansi = {
    rainbow_extended.dark_gray,     -- Black (0): Readable dark gray
    rainbow_extended.light_red,     -- Red (1): Pride red, lightened for readability
    rainbow_extended.light_green,   -- Green (2): Pride green, lightened
    rainbow_extended.light_yellow,  -- Yellow (3): Pride yellow, lightened
    rainbow_extended.light_blue,    -- Blue (4): Pride blue, lightened
    rainbow_extended.light_purple,  -- Magenta (5): Pride purple, lightened
    rainbow_extended.pride_orange,  -- Cyan (6): Pride orange as cyan substitute
    rainbow_extended.light_gray,    -- White (7): Light gray for text
  },
  
  -- Bright Colors (8-15) - Full intensity rainbow
  brights = {
    rainbow_extended.medium_gray,   -- Bright Black (8)
    rainbow_extended.pride_red,     -- Bright Red (9): Full pride red
    rainbow_extended.pride_green,   -- Bright Green (10): Full pride green  
    rainbow_extended.pride_yellow,  -- Bright Yellow (11): Full pride yellow
    rainbow_extended.pride_blue,    -- Bright Blue (12): Full pride blue
    rainbow_extended.pride_purple,  -- Bright Magenta (13): Full pride purple
    rainbow_extended.pride_orange,  -- Bright Cyan (14): Full pride orange
    rainbow_extended.bright_white,  -- Bright White (15): Pure white
  },
  
  -- Extended indexed colors - Rainbow spectrum
  indexed = {
    [16] = rainbow_extended.pride_red,
    [17] = rainbow_extended.pride_orange, 
    [18] = rainbow_extended.pride_yellow,
    [19] = rainbow_extended.pride_green,
    [20] = rainbow_extended.pride_blue,
    [21] = rainbow_extended.pride_purple,
    [22] = rainbow_extended.light_red,
    [23] = rainbow_extended.light_orange,
    [24] = rainbow_extended.light_yellow,
    [25] = rainbow_extended.light_green,
    [26] = rainbow_extended.light_blue,
    [27] = rainbow_extended.light_purple,
  },
  
  -- Tab bar - Rainbow gradient effect
  tab_bar = {
    background = "#0A0A0F",
    active_tab = {
      bg_color = rainbow_extended.pride_purple,
      fg_color = rainbow_extended.bright_white,
    },
    inactive_tab = {
      bg_color = "#1A1A2E",
      fg_color = rainbow_extended.medium_gray,
    },
    inactive_tab_hover = {
      bg_color = rainbow_extended.pride_blue,
      fg_color = rainbow_extended.bright_white,
    },
    new_tab = {
      bg_color = "#1A1A2E", 
      fg_color = rainbow_extended.medium_gray,
    },
    new_tab_hover = {
      bg_color = rainbow_extended.pride_green,
      fg_color = rainbow_extended.bright_white,
    },
  },
}

-- NEW: LGBT Light Rainbow Theme
local lgbt_light_theme = {
  -- Base colors - Clean light background
  foreground = "#1A1A1A",                     -- Very dark text for maximum readability
  background = "#FEFEFE",                     -- Pure white background
  
  -- Cursor - Strong rainbow accent
  cursor_bg = rainbow_extended.pride_purple,
  cursor_border = rainbow_extended.pride_purple, 
  cursor_fg = rainbow_extended.bright_white,
  
  -- Selection - Light rainbow accent
  selection_bg = "#E1BEE7",  -- Light purple selection
  selection_fg = "#1A1A1A",
  
  -- ANSI Colors (0-7) - Dark rainbow for excellent contrast on light background
  ansi = {
    rainbow_extended.soft_black,    -- Black (0): True black for contrast
    rainbow_extended.dark_red,      -- Red (1): Dark pride red
    rainbow_extended.dark_green,    -- Green (2): Dark pride green
    rainbow_extended.dark_yellow,   -- Yellow (3): Dark pride yellow (more orange)
    rainbow_extended.dark_blue,     -- Blue (4): Dark pride blue
    rainbow_extended.dark_purple,   -- Magenta (5): Dark pride purple
    rainbow_extended.dark_orange,   -- Cyan (6): Dark pride orange as cyan
    rainbow_extended.dark_gray,     -- White (7): Dark gray
  },
  
  -- Bright Colors (8-15) - Medium intensity rainbow for balance
  brights = {
    rainbow_extended.medium_gray,   -- Bright Black (8)
    rainbow_extended.pride_red,     -- Bright Red (9): Standard pride red
    rainbow_extended.pride_green,   -- Bright Green (10): Standard pride green
    "#FFD700",                      -- Bright Yellow (11): Gold for better light visibility
    rainbow_extended.pride_blue,    -- Bright Blue (12): Standard pride blue
    rainbow_extended.pride_purple,  -- Bright Magenta (13): Standard pride purple
    rainbow_extended.pride_orange,  -- Bright Cyan (14): Standard pride orange
    rainbow_extended.soft_black,    -- Bright White (15): Black text on light background
  },
  
  -- Extended indexed colors - Rainbow spectrum adapted for light theme
  indexed = {
    [16] = rainbow_extended.dark_red,
    [17] = rainbow_extended.dark_orange,
    [18] = rainbow_extended.dark_yellow, 
    [19] = rainbow_extended.dark_green,
    [20] = rainbow_extended.dark_blue,
    [21] = rainbow_extended.dark_purple,
    [22] = rainbow_extended.pride_red,
    [23] = rainbow_extended.pride_orange,
    [24] = "#FFD700", -- Gold instead of yellow for visibility
    [25] = rainbow_extended.pride_green,
    [26] = rainbow_extended.pride_blue,
    [27] = rainbow_extended.pride_purple,
  },
  
  -- Tab bar - Clean with rainbow accents
  tab_bar = {
    background = "#F5F5F5",
    active_tab = {
      bg_color = rainbow_extended.bright_white,
      fg_color = rainbow_extended.pride_purple,
    },
    inactive_tab = {
      bg_color = "#F5F5F5",
      fg_color = rainbow_extended.dark_gray,
    },
    inactive_tab_hover = {
      bg_color = "#E8F4FD",  -- Light blue hover
      fg_color = rainbow_extended.pride_blue,
    },
    new_tab = {
      bg_color = "#F5F5F5",
      fg_color = rainbow_extended.dark_gray,
    },
    new_tab_hover = {
      bg_color = "#FFF3E0",  -- Light orange hover
      fg_color = rainbow_extended.pride_orange,
    },
  },
}

-- Enhanced status bar function that supports all themes
wezterm.on("update-right-status", function(window, pane)
  local current_theme = read_theme()
  local status_color = STATUS_PINK -- Default status color
  local theme_indicator = ""
  
  -- Set theme-specific status colors and indicators
  if current_theme == "lgbt_dark" then
    local time = os.time()
    local rainbow_cycle = {
      rainbow_extended.pride_red,
      rainbow_extended.pride_orange,
      rainbow_extended.pride_yellow, 
      rainbow_extended.pride_green,
      rainbow_extended.pride_blue,
      rainbow_extended.pride_purple
    }
    -- Cycle through rainbow colors every 10 seconds
    local color_index = (math.floor(time / 10) % #rainbow_cycle) + 1
    status_color = rainbow_cycle[color_index]
    theme_indicator = "🏳️‍🌈"
  elseif current_theme == "lgbt_light" then
    local time = os.time()
    local rainbow_cycle = {
      rainbow_extended.dark_red,
      rainbow_extended.dark_orange,
      rainbow_extended.dark_yellow, 
      rainbow_extended.dark_green,
      rainbow_extended.dark_blue,
      rainbow_extended.dark_purple
    }
    -- Cycle through darker rainbow colors every 10 seconds for light theme
    local color_index = (math.floor(time / 10) % #rainbow_cycle) + 1
    status_color = rainbow_cycle[color_index]
    theme_indicator = "🏳️‍🌈"
  else
    -- Default pink for original themes
    status_color = STATUS_PINK
  end

  -- Get current date and time
  local date = wezterm.strftime("%a %b %d")
  local time_str = wezterm.strftime("%H:%M")

  -- Format status text
  local status_text = string.format(" %s%s  %s ", theme_indicator, date, time_str)

  -- Create elements with appropriate color
  local elements = {}
  table.insert(elements, { Foreground = { Color = status_color } })
  table.insert(elements, { Text = status_text })

  -- Set the right status
  window:set_right_status(wezterm.format(elements))
end)

-- Apply the selected theme based on theme file
local theme = read_theme()
if theme == "dark" then
  config.colors = dark_theme
elseif theme == "light" then
  config.colors = light_theme
elseif theme == "lgbt_dark" then
  config.colors = lgbt_dark_theme
elseif theme == "lgbt_light" then
  config.colors = lgbt_light_theme
else
  config.colors = dark_theme -- fallback to dark
end

-- Font configuration - Make everything bold
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "ExtraBold" })
config.font_size = 14

-- NEW: Font rules to ensure ALL text renders as bold, including input/output text
config.font_rules = {
  -- Rule for normal text (make it bold)
  {
    intensity = "Normal",
    italic = false,
    font = wezterm.font({
      family = "JetBrainsMono Nerd Font",
      weight = "ExtraBold", -- Make normal text bold
    }),
  },
  -- Rule for half-intensity text (make it bold too)
  {
    intensity = "Half",
    italic = false,
    font = wezterm.font({
      family = "JetBrainsMono Nerd Font",
      weight = "ExtraBold", -- Keep half-intensity text bold
    }),
  },
  -- Rule for already bold text (make it extra bold)
  {
    intensity = "Bold",
    italic = false,
    font = wezterm.font({
      family = "JetBrainsMono Nerd Font",
      weight = "ExtraBold", -- Make bold text even bolder
    }),
  },
  -- Rule for italic text (make it bold italic)
  {
    intensity = "Normal",
    italic = true,
    font = wezterm.font({
      family = "JetBrainsMono Nerd Font",
      weight = "ExtraBold",
      italic = true,
    }),
  },
  -- Rule for bold italic text
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font({
      family = "JetBrainsMono Nerd Font",
      weight = "ExtraBold",
      italic = true,
    }),
  },
}

-- Force bold settings
config.bold_brightens_ansi_colors = false
config.allow_square_glyphs_to_overflow_width = "Always"

-- NEW: Set normal text to bold without changing color
config.font_shaper = "Harfbuzz"                                       -- Use the most capable text shaper
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1", "dlig=1" } -- Enable all ligatures

-- Window settings
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 10

-- macOS Command Key Configuration - COMPLETE FIX
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- COMPLETE Command key bindings for macOS behavior
config.keys = {
  -- ============================================================================
  -- TEXT EDITING - Standard macOS shortcuts
  -- ============================================================================

  -- Command+A - Select All
  {
    key = 'a',
    mods = 'CMD',
    action = act.SendKey { key = 'a', mods = 'CTRL' },
  },

  -- Command+C - Copy
  {
    key = 'c',
    mods = 'CMD',
    action = act.CopyTo 'Clipboard',
  },

  -- Command+V - Paste
  {
    key = 'v',
    mods = 'CMD',
    action = act.PasteFrom 'Clipboard',
  },

  -- Command+X - Cut
  {
    key = 'x',
    mods = 'CMD',
    action = act.Multiple {
      act.SendKey { key = 'a', mods = 'CTRL' },
      act.CopyTo 'Clipboard',
      act.SendKey { key = 'u', mods = 'CTRL' },
    },
  },

  -- Command+Z - Undo
  {
    key = 'z',
    mods = 'CMD',
    action = act.SendKey { key = 'z', mods = 'CTRL' },
  },

  -- Command+Y - Redo
  {
    key = 'y',
    mods = 'CMD',
    action = act.SendKey { key = 'y', mods = 'CTRL' },
  },

  -- ============================================================================
  -- CURSOR MOVEMENT - macOS style navigation
  -- ============================================================================

  -- Command+Left Arrow - Beginning of line
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = act.SendKey { key = 'a', mods = 'CTRL' },
  },

  -- Command+Right Arrow - End of line
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = act.SendKey { key = 'e', mods = 'CTRL' },
  },

  -- FIXED: Command+E - End of line (this was missing!)
  {
    key = 'e',
    mods = 'CMD',
    action = act.SendKey { key = 'e', mods = 'CTRL' },
  },

  -- Option+Left Arrow - Previous word
  {
    key = 'LeftArrow',
    mods = 'ALT',
    action = act.SendKey { key = 'b', mods = 'ALT' },
  },

  -- Option+Right Arrow - Next word
  {
    key = 'RightArrow',
    mods = 'ALT',
    action = act.SendKey { key = 'f', mods = 'ALT' },
  },

  -- ============================================================================
  -- TEXT SELECTION - Proper selection with Shift modifier keys
  -- ============================================================================

  -- Command+Shift+Left Arrow - Select to beginning of line and copy
  {
    key = 'LeftArrow',
    mods = 'CMD|SHIFT',
    action = act.SendString('\x1b[1;6D'),
  },

  -- Command+Shift+Right Arrow - Select to end of line and copy
  {
    key = 'RightArrow',
    mods = 'CMD|SHIFT',
    action = act.SendString('\x1b[1;6C'),
  },

  -- Option+Shift+Left Arrow - Select previous word and copy
  {
    key = 'LeftArrow',
    mods = 'ALT|SHIFT',
    action = act.SendString('\x1b[1;4D'),
  },

  -- Option+Shift+Right Arrow - Select next word and copy
  {
    key = 'RightArrow',
    mods = 'ALT|SHIFT',
    action = act.SendString('\x1b[1;4C'),
  },

  -- Shift+Left Arrow - Select character by character
  {
    key = 'LeftArrow',
    mods = 'SHIFT',
    action = act.SendKey { key = 'LeftArrow', mods = 'SHIFT' },
  },

  -- Shift+Right Arrow - Select character by character
  {
    key = 'RightArrow',
    mods = 'SHIFT',
    action = act.SendKey { key = 'RightArrow', mods = 'SHIFT' },
  },

  -- ============================================================================
  -- COPY/PASTE (STANDARD)
  -- ============================================================================

  -- Command+C - Copy
  {
    key = 'c',
    mods = 'CMD',
    action = act.CopyTo 'Clipboard',
  },

  -- Command+V - Paste
  {
    key = 'v',
    mods = 'CMD',
    action = act.PasteFrom 'Clipboard',
  },

  -- Command+Z - Undo
  {
    key = 'z',
    mods = 'CMD',
    action = act.SendKey { key = 'z', mods = 'CTRL' },
  },

  -- ============================================================================
  -- TERMINAL SPECIFIC
  -- ============================================================================

  -- Command+T - New Tab
  {
    key = 't',
    mods = 'CMD',
    action = act.SpawnTab 'CurrentPaneDomain',
  },

  -- Command+W - Close Tab
  {
    key = 'w',
    mods = 'CMD',
    action = act.CloseCurrentTab { confirm = false },
  },

  -- Command+N - New Window
  {
    key = 'n',
    mods = 'CMD',
    action = act.SpawnWindow,
  },

  -- Command+Q - Quit Application
  {
    key = 'q',
    mods = 'CMD',
    action = act.QuitApplication,
  },

  -- Command+R - Reload Configuration
  {
    key = 'r',
    mods = 'CMD',
    action = act.ReloadConfiguration,
  },

  -- Command+M - Minimize Window
  {
    key = 'm',
    mods = 'CMD',
    action = act.Hide,
  },

  -- ============================================================================
  -- FONT SIZE
  -- ============================================================================

  -- Command+Plus - Increase Font Size
  {
    key = '=',
    mods = 'CMD',
    action = act.IncreaseFontSize,
  },
  {
    key = '+',
    mods = 'CMD',
    action = act.IncreaseFontSize,
  },

  -- Command+Minus - Decrease Font Size
  {
    key = '-',
    mods = 'CMD',
    action = act.DecreaseFontSize,
  },

  -- Command+0 - Reset Font Size
  {
    key = '0',
    mods = 'CMD',
    action = act.ResetFontSize,
  },

  -- Command+Shift+O - Toggle Always on Top (moved from T to avoid conflict)
  {
    key = 'o',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local overrides = window:get_config_overrides() or {}
      if not overrides.window_level then
        overrides.window_level = "AlwaysOnTop"
      else
        overrides.window_level = nil
      end
      window:set_config_overrides(overrides)
    end),
  },

  -- ============================================================================
  -- NEW: LGBT THEME SWITCHING KEYBINDS
  -- ============================================================================

  -- Command+Shift+1 - Switch to LGBT Dark Theme
  {
    key = '1',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      -- Write lgbt_dark to theme file
      local theme_file = io.open(os.getenv("HOME") .. "/.config/wezterm/theme", "w")
      if theme_file then
        theme_file:write("lgbt_dark")
        theme_file:close()
      end
      
      -- Apply theme immediately
      local overrides = window:get_config_overrides() or {}
      overrides.colors = lgbt_dark_theme
      window:set_config_overrides(overrides)
      
      -- Show notification
      window:toast_notification('WezTerm', 'Switched to LGBT Dark Rainbow Theme 🏳️‍🌈', nil, 2000)
    end),
  },

  -- Command+Shift+2 - Switch to LGBT Light Theme
  {
    key = '2',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      -- Write lgbt_light to theme file
      local theme_file = io.open(os.getenv("HOME") .. "/.config/wezterm/theme", "w")
      if theme_file then
        theme_file:write("lgbt_light")
        theme_file:close()
      end
      
      -- Apply theme immediately
      local overrides = window:get_config_overrides() or {}
      overrides.colors = lgbt_light_theme
      window:set_config_overrides(overrides)
      
      -- Show notification
      window:toast_notification('WezTerm', 'Switched to LGBT Light Rainbow Theme 🏳️‍🌈', nil, 2000)
    end),
  },

  -- Command+Shift+3 - Switch to Original Dark Theme
  {
    key = '3',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      -- Write dark to theme file
      local theme_file = io.open(os.getenv("HOME") .. "/.config/wezterm/theme", "w")
      if theme_file then
        theme_file:write("dark")
        theme_file:close()
      end
      
      -- Apply theme immediately
      local overrides = window:get_config_overrides() or {}
      overrides.colors = dark_theme
      window:set_config_overrides(overrides)
      
      -- Show notification
      window:toast_notification('WezTerm', 'Switched to Original Dark Theme', nil, 2000)
    end),
  },

  -- Command+Shift+4 - Switch to Original Light Theme
  {
    key = '4',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      -- Write light to theme file
      local theme_file = io.open(os.getenv("HOME") .. "/.config/wezterm/theme", "w")
      if theme_file then
        theme_file:write("light")
        theme_file:close()
      end
      
      -- Apply theme immediately
      local overrides = window:get_config_overrides() or {}
      overrides.colors = light_theme
      window:set_config_overrides(overrides)
      
      -- Show notification
      window:toast_notification('WezTerm', 'Switched to Original Light Theme', nil, 2000)
    end),
  },

  -- ============================================================================
  -- TAB NAVIGATION BY NUMBER (Command+5-9)
  -- ============================================================================

  -- Command+5 through Command+9 for direct tab switching (continuing from theme switchers)
  {
    key = '5',
    mods = 'CMD',
    action = act.ActivateTab(4),
  },
  {
    key = '6',
    mods = 'CMD',
    action = act.ActivateTab(5),
  },
  {
    key = '7',
    mods = 'CMD',
    action = act.ActivateTab(6),
  },
  {
    key = '8',
    mods = 'CMD',
    action = act.ActivateTab(7),
  },
  {
    key = '9',
    mods = 'CMD',
    action = act.ActivateTab(8),
  },

  -- ============================================================================
  -- PANE MANAGEMENT
  -- ============================================================================

  -- Command+D - Split horizontally
  {
    key = 'd',
    mods = 'CMD',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },

  -- Command+Shift+D - Split vertically
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Command+Shift+W - Close current pane
  {
    key = 'w',
    mods = 'CMD|SHIFT',
    action = act.CloseCurrentPane { confirm = true },
  },

  -- Pane navigation with Command+Option+Arrow keys
  {
    key = 'LeftArrow',
    mods = 'CMD|ALT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow', 
    mods = 'CMD|ALT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'CMD|ALT', 
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'CMD|ALT',
    action = act.ActivatePaneDirection 'Down',
  },

  -- ============================================================================
  -- ENHANCED SEARCH
  -- ============================================================================

  -- Command+F - Search with current selection or empty
  {
    key = 'f',
    mods = 'CMD',
    action = act.Search 'CurrentSelectionOrEmptyString',
  },

  -- ============================================================================
  -- COPY MODE AND HISTORY NAVIGATION
  -- ============================================================================

  -- Command+[ - Enter copy mode for history navigation
  {
    key = '[',
    mods = 'CMD',
    action = act.ActivateCopyMode,
  },

  -- Page up/down in scrollback
  {
    key = 'PageUp',
    mods = 'CMD',
    action = act.ScrollByPage(-1),
  },
  {
    key = 'PageDown',
    mods = 'CMD', 
    action = act.ScrollByPage(1),
  },

  -- ============================================================================
  -- ADVANCED TAB MANAGEMENT  
  -- ============================================================================

  -- Move tabs left/right
  {
    key = 'LeftArrow',
    mods = 'CMD|SHIFT|ALT',
    action = act.MoveTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = 'CMD|SHIFT|ALT', 
    action = act.MoveTabRelative(1),
  },

  -- Cycle through tabs
  {
    key = 'Tab',
    mods = 'CMD',
    action = act.ActivateTabRelative(1),
  },
  {
    key = 'Tab',
    mods = 'CMD|SHIFT',
    action = act.ActivateTabRelative(-1),
  },

  -- ============================================================================
  -- PANE ZOOM
  -- ============================================================================

  -- Command+Shift+Z - Toggle pane zoom (avoiding conflict with undo)
  {
    key = 'z',
    mods = 'CMD|SHIFT',
    action = act.TogglePaneZoomState,
  },

  -- ============================================================================
  -- CONFIG ACCESS
  -- ============================================================================

  -- Command+, - Open config (standard macOS pattern)
  {
    key = ',',
    mods = 'CMD',
    action = act.SpawnCommandInNewWindow {
      cwd = wezterm.home_dir,
      args = { 'nvim', wezterm.config_file },
    },
  },

  -- ============================================================================
  -- ADDITIONAL WINDOW MANAGEMENT
  -- ============================================================================

  -- Command+H - Hide window (standard macOS)
  {
    key = 'h',
    mods = 'CMD',
    action = act.Hide,
  },

  -- ============================================================================
  -- DELETION - Additional macOS style deletion
  -- ============================================================================

  -- Command+Backspace - Delete to beginning of line
  {
    key = 'Backspace',
    mods = 'CMD',
    action = act.SendKey { key = 'u', mods = 'CTRL' },
  },

  -- Command+Delete - Delete to beginning of line  
  {
    key = 'Delete',
    mods = 'CMD',
    action = act.SendKey { key = 'u', mods = 'CTRL' },
  },

  -- Command+K - Delete to end of line
  {
    key = 'k',
    mods = 'CMD',
    action = act.SendKey { key = 'k', mods = 'CTRL' },
  },

  -- Option+Backspace - Delete previous word
  {
    key = 'Backspace',
    mods = 'ALT',
    action = act.SendKey { key = 'w', mods = 'CTRL' },
  },

  -- ============================================================================
  -- NEWLINE INSERTION
  -- ============================================================================

  -- Shift+Enter - Insert newline (like in Claude)
  {
    key = 'Enter',
    mods = 'SHIFT',
    action = act.SendString '\n',
  },

  -- ============================================================================
  -- VS CODE LAYOUT AUTOMATION
  -- ============================================================================

  -- Command+Shift+L - Launch VS Code-like layout with WezTerm
  {
    key = 'l',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      -- Get current working directory
      local cwd = pane:get_current_working_dir()
      local path = cwd and cwd.file_path or os.getenv("HOME")

      -- Create the VS Code-like layout directly in WezTerm
      -- Split vertically (sidebar on left, main area on right)
      local right_pane = pane:split { direction = "Right", size = 0.75 }

      -- Split the right pane horizontally (code on top, terminal on bottom)
      local bottom_pane = right_pane:split { direction = "Bottom", size = 0.3 }

      -- Set up each pane with helpful messages and clear them
      pane:send_text("clear\n")
      pane:send_text("echo '📁 File Browser - Use: lf, ranger, or tree'\n")

      right_pane:send_text("clear\n")
      right_pane:send_text("echo '💻 Ready for coding! 🚀'\n")
      right_pane:send_text("echo 'Use: nvim . or code .'\n")

      bottom_pane:send_text("clear\n")
      bottom_pane:send_text("echo '⚡ Terminal ready!'\n")

      -- Focus on the file browser pane
      pane:activate()

      -- Show notification
      window:toast_notification('WezTerm', 'VS Code-like layout created! 🚀', nil, 2000)
    end),
  },

  -- Command+Shift+G - Launch tmux dev session (G for "Go to dev")
  {
    key = 'g',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      wezterm.log_info("Triggered tmux layout via Cmd+Shift+G")

      -- Get current working directory
      local cwd = pane:get_current_working_dir()
      local path = cwd and cwd.file_path or os.getenv("HOME")
      if path then path = path:gsub("^file://", "") end

      -- Check if we're already in tmux
      local in_tmux = os.getenv("TMUX") ~= nil

      -- Check if session "dev" already exists
      local success, stdout, stderr = wezterm.run_child_process({
        "tmux", "has-session", "-t", "dev"
      })

      if in_tmux then
        -- Already in tmux, switch to dev session
        if success then
          pane:send_text("tmux switch-client -t dev\r")
        else
          -- Create dev session in background then switch
          pane:send_text(os.getenv("HOME") .. "/.config/scripts/tmux-dev-layout.sh dev " .. path .. "\r")
        end
      else
        -- Not in tmux, attach or create
        if success then
          pane:send_text("tmux attach-session -t dev\r")
        else
          pane:send_text(os.getenv("HOME") .. "/.config/scripts/tmux-dev-layout.sh dev " .. path .. "\r")
        end
      end

      window:toast_notification('WezTerm', 'Launching tmux "dev" session 🚀', nil, 2000)
    end),
  },
}

-- ============================================================================
-- MOUSE SUPPORT
-- ============================================================================

-- Enable better mouse support
config.mouse_bindings = {
  -- Triple-click to select line
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = act.SelectTextAtMouseCursor 'Line',
  },

  -- Command+Click to open links
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = act.OpenLinkAtMouseCursor,
  },
}

-- Make theme switching more responsive
wezterm.on("window-config-reload", function(window, pane)
  -- Force a redraw when config is reloaded
  window:set_right_status("Theme changed")
  wezterm.sleep_ms(1000)
  window:set_right_status("")
end)

-- Performance settings
config.front_end = "WebGpu" -- newer renderer, better performance on modern hardware
config.webgpu_power_preference = "HighPerformance"
config.animation_fps = 30   -- lower from default 60 to save resources
config.max_fps = 60         -- cap framerate

-- Enable GPU acceleration
config.webgpu_preferred_adapter = {
  name = "default",
  backend = "Vulkan",
  device_type = "DiscreteGpu",
}

return config