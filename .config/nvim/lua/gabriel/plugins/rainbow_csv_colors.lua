-- ~/.config/nvim/lua/gabriel/plugins/rainbow_csv_colors.lua
-- Enhanced CSV colors with terminal compatibility
return {
  {
    "mechatroner/rainbow_csv",
    lazy = false,
    config = function()
      -- Get current theme from WezTerm config or fallback to vim background
      local function get_theme()
        local file = io.open(os.getenv("HOME") .. "/.config/wezterm/theme", "r")
        if file then
          local theme = file:read("*all")
          file:close()
          return theme:gsub("%s+", "") -- Trim whitespace
        else
          -- Fallback to vim background
          return vim.o.background
        end
      end

      -- Define color schemes using only standard terminal color names/numbers
      local color_schemes = {
        -- Light theme colors using standard terminal colors
        light = {
          { "blue", "#0550AE" }, -- Strong blue
          { "red", "#D70000" }, -- Bold red
          { "green", "#007F0E" }, -- Forest green
          { "magenta", "#8000FF" }, -- Rich purple
          { "yellow", "#B8860B" }, -- Dark gold
          { "cyan", "#009FAA" }, -- Bright cyan
          { "brown", "#A05A2C" }, -- Chocolate brown
          { "gray", "#808080" }, -- Standard gray
          -- Use numbers for additional colors
          { 1, "#FF5555" }, -- light red
          { 2, "#118399" }, -- light green
          { 3, "#FFFF55" }, -- light yellow
          { 4, "#5555FF" }, -- light blue
          { 5, "#FF55FF" }, -- light magenta
          { 6, "#55FFFF" }, -- light cyan
          { 9, "#FF8800" }, -- bright red/orange
          { 10, "Black" }, -- bright green
          { 11, "#FFAA00" }, -- bright yellow
          { 12, "#8800FF" }, -- bright blue/purple
          { 13, "#FF0088" }, -- bright magenta
          { 14, "#00AAFF" }, -- bright cyan
        },

        -- Dark theme colors using standard terminal colors:
        dark = {
          { "blue", "#61AFEF" }, -- Bright Blue
          { "red", "#FF5370" }, -- Coral Red
          { "green", "#3EFFDC" }, -- Bright Mint
          { "magenta", "#BB9AF7" }, -- Light Purple
          { "yellow", "#FFDA7B" }, -- Light Gold
          { "cyan", "#56B6C2" }, -- Bright Cyan
          { "white", "#FFFFFF" }, -- White
          { "gray", "#AAAAAA" }, -- Light gray
          -- Use numbers for additional colors
          { 1, "#FF5555" }, -- light red
          { 2, "#55FF55" }, -- light green
          { 3, "#FFFF55" }, -- light yellow
          { 4, "#5555FF" }, -- light blue
          { 5, "#FF55FF" }, -- light magenta
          { 6, "#55FFFF" }, -- light cyan
          { 9, "#FF8800" }, -- bright red/orange
          { 10, "#88FF00" }, -- bright green
          { 11, "#FFAA00" }, -- bright yellow
          { 12, "#8800FF" }, -- bright blue/purple
          { 13, "#FF0088" }, -- bright magenta
          { 14, "#00AAFF" }, -- bright cyan
        },
      }

      -- Apply the appropriate color scheme based on theme
      local current_theme = get_theme()
      if current_theme == "light" or current_theme == "latte" then
        vim.g.rcsv_colorpairs = color_schemes.light
      else
        vim.g.rcsv_colorpairs = color_schemes.dark
      end

      -- Create a command to refresh the colors manually
      vim.api.nvim_create_user_command("RainbowEnhanceColors", function()
        -- Re-detect theme and apply appropriate colors
        local theme = get_theme()
        if theme == "light" or theme == "latte" then
          vim.g.rcsv_colorpairs = color_schemes.light
        else
          vim.g.rcsv_colorpairs = color_schemes.dark
        end

        -- Apply stronger highlighting for specific rainbow columns
        for i = 1, 20 do
          local color_name = "rainbowcol" .. i
          vim.cmd("highlight " .. color_name .. " gui=bold")
        end

        -- Force rainbow highlighting to be reapplied
        vim.cmd("RainbowDelimSimple")

        vim.notify("Enhanced CSV colors applied for " .. theme .. " theme", vim.log.levels.INFO)
      end, {})

      -- Apply enhancements immediately after rainbow highlighting is applied
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "csv", "tsv", "dat" },
        callback = function()
          -- Wait a short time for rainbow_csv to initialize its colors
          vim.defer_fn(function()
            -- Apply bolding to all rainbow column highlighting
            for i = 1, 20 do
              local color_name = "rainbowcol" .. i
              vim.cmd("highlight " .. color_name .. " gui=bold")
            end
          end, 100)

          -- Create keybinding to reapply colors if needed
          vim.keymap.set("n", "<leader>ch", function()
            vim.cmd("RainbowEnhanceColors")
          end, { buffer = true, desc = "Enhance CSV colors" })
        end,
      })

      -- Also apply enhancement after any RainbowDelim command
      vim.api.nvim_create_autocmd("CmdlineLeave", {
        pattern = "*",
        callback = function()
          local cmd = vim.fn.getcmdline()
          if cmd:match("^RainbowDelim") or cmd:match("^Rainbow") then
            vim.defer_fn(function()
              vim.cmd("RainbowEnhanceColors")
            end, 100)
          end
        end,
      })

      -- Apply colors on theme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Re-detect theme and set appropriate colors
          local theme = get_theme()
          if theme == "light" or theme == "latte" then
            vim.g.rcsv_colorpairs = color_schemes.light
          else
            vim.g.rcsv_colorpairs = color_schemes.dark
          end

          -- Defer enhancement to ensure it applies after colorscheme change
          vim.defer_fn(function()
            for i = 1, 20 do
              local color_name = "rainbowcol" .. i
              vim.cmd("highlight " .. color_name .. " gui=bold")
            end
          end, 100)
        end,
      })
    end,
  },
}
