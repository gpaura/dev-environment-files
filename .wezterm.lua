local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

config.window_close_confirmation = "NeverPrompt"
config.quit_when_all_windows_are_closed = true

-- Remove or comment out initial_cols/rows if using this method
wezterm.on('gui-startup', function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	
	-- Set exact size in pixels
	local window_width = 2100   -- Adjust this
	local window_height = 1350   -- Adjust this
	
	-- Center on screen
	local screen = wezterm.gui.screens().active
	local x = (screen.width - window_width) / 2
	local y = (screen.height - window_height) / 2
	
	window:gui_window():set_inner_size(window_width, window_height)
	window:gui_window():set_position(x, y)
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

-- Define the pink color for status information (RGB: close to pink 198)
local STATUS_PINK = "#FF40A3"

-- Define Dark Theme
local dark_theme = {
	-- Base colors
	foreground = "#F8F8F2", -- Bright off-white from Dracula for text
	background = "#1A1B26", -- Deep blue-black from Tokyo Night

	-- Cursor
	cursor_bg = "#FF79C6", -- Bright pink from Dracula
	cursor_border = "#FF79C6", -- Matching border
	cursor_fg = "#282A36", -- Dark background from Dracula for text under cursor

	-- Selection
	selection_bg = "#44475A", -- Dracula selection color
	selection_fg = "#F8F8F2", -- Same as foreground

	-- ANSI Colors (0-7) - Rich and vibrant fusion
	ansi = {
		"#414868", -- Black (0): Tokyo Night dark blue-gray
		"#FF5555", -- Red (1): Dracula red
		"#50FA7B", -- Green (2): Dracula green
		STATUS_PINK, -- Yellow (3): Changed to pink (was Monokai Pro yellow)
		"#7AA2F7", -- Blue (4): Tokyo Night blue
		"#FF79C6", -- Magenta (5): Dracula pink
		"#8BE9FD", -- Cyan (6): Dracula cyan
		"#ACAAB6", -- White (7): Light gray based on Tokyo Night
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

-- Define Light Theme
local light_theme = {
	-- Base colors
	foreground = "#2D2A2E", -- Darker gray for better contrast on light background
	background = "#FAFAFA", -- Keeping the same clean off-white

	-- Cursor
	cursor_bg = "#FF2D76", -- More intense pink cursor
	cursor_border = "#FF2D76", -- Matching border
	cursor_fg = "#FFFFFF", -- White text under cursor

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
		[17] = "#C49E3F", -- Darker, more visible gold
		[18] = "#AA7800", -- Much darker gold for visibility
		[19] = "#FF42A1", -- More vibrant pink
		[20] = "#A64DFF", -- Stronger purple
		[21] = "#8F95A0", -- Darker gray for visibility
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

-- Set up status bar with date and time
wezterm.on("update-right-status", function(window, pane)
	-- Get current date and time
	local date = wezterm.strftime("%a %b %d")
	local time = wezterm.strftime("%H:%M")

	-- Format status text
	local status_text = string.format(" %s  %s ", date, time)

	-- Create elements with pink color
	local elements = {}
	table.insert(elements, { Foreground = { Color = STATUS_PINK } })
	table.insert(elements, { Text = status_text })

	-- Set the right status
	window:set_right_status(wezterm.format(elements))
end)

-- Apply the selected theme
local theme = read_theme()
if theme == "dark" then
	config.colors = dark_theme
else
	config.colors = light_theme
end

-- Font configuration - Make everything bold
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "ExtraBold" })
config.font_size = 19

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
config.font_shaper = "Harfbuzz" -- Use the most capable text shaper
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1", "dlig=1" } -- Enable all ligatures

-- Window settings
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 10

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
config.animation_fps = 30 -- lower from default 60 to save resources
config.max_fps = 60 -- cap framerate

-- Enable GPU acceleration
config.webgpu_preferred_adapter = {
	name = "default",
	backend = "Vulkan",
	device_type = "DiscreteGpu",
}

return config
