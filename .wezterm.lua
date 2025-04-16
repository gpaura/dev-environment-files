local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Function to read the theme from a file
local function read_theme()
  local file = io.open(os.getenv("HOME") .. "/.config/wezterm/theme", "r")
  if file then
    local theme = file:read("*all")
    file:close()
    return theme:gsub("%s+", "") -- Trim whitespace
  else
    return "light" -- Default to light theme
  end
end


-- Define Dark Theme
local dark_theme = {
  foreground = "#CBE0F0",
  background = "#011423",
  cursor_fg = "black",         -- text under cursor
  cursor_bg = "#FF00AA",       -- hot pink background
  cursor_border = "#FF00AA",   -- hot pink border
  selection_bg = "#033259",
  selection_fg = "#CBE0F0",
  ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
  brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

-- Define Light Theme
local light_theme = {
  foreground = "#2D2A2E",
  background = "#F4F4F4",
  cursor_bg = "#F78C6C",
  cursor_border = "#F78C6C",
  cursor_fg = "#FF00AA",
  selection_bg = "#F4E1D2",
  selection_fg = "#2D2A2E",
  ansi = { "#D14E6A", "#F72D1E", "#66D354", "#F7B45C", "#5A68A3", "#D162D6", "#00B0B9", "#A1D8D8" },
  brights = { "#F72D1E", "#D14E6A", "#66D354", "#F7B45C", "#5A68A3", "#D162D6", "#00B0B9", "#A1D8D8" },
}

-- Apply the selected theme
local theme = read_theme()
if theme == "dark" then
  config.colors = dark_theme
else
  config.colors = light_theme
end

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })
config.font_size = 19
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 10

return config
