-- ~/.config/nvim/lua/gabriel/plugins/rainbow_csv_colors.lua
-- Add this file to your Neovim configuration for enhanced CSV colors

return {
  {
    "mechatroner/rainbow_csv",
    lazy = false,
    config = function()
      -- Define a custom color scheme with strong, bold colors that won't repeat quickly
      -- Using only standard terminal color names and numbers for compatibility
      vim.g.rcsv_colorpairs = {
        {'red',     '#FF0000'},
        {'blue',    '#0000FF'},
        {'green',   '#00FF00'},
        {'magenta', '#FF00FF'},
        {'yellow',  '#FFFF00'},
        {'cyan',    '#00FFFF'},
        {'brown',   '#AA5500'},
        {'gray',    '#AAAAAA'},
        -- Use numbers for terminal colors beyond the standard names
        {1,         '#FF5555'}, -- light red
        {4,         '#5555FF'}, -- light blue
        {2,         '#55FF55'}, -- light green
        {5,         '#FF55FF'}, -- light magenta
        {3,         '#FFFF55'}, -- light yellow
        {6,         '#55FFFF'}, -- light cyan
        {9,         '#FF8800'}, -- bright red/orange
        {12,        '#8800FF'}, -- bright blue/purple
        {10,        '#88FF00'}, -- bright green
        {13,        '#FF0088'}, -- bright magenta
        {11,        '#FFAA00'}, -- bright yellow
        {14,        '#00AAFF'}, -- bright cyan
      }
      
      -- Create a command to refresh the colors manually
      vim.api.nvim_create_user_command("RainbowEnhanceColors", function()
        -- Apply stronger highlighting for specific rainbow columns
        for i = 1, 20 do
          local color_name = "rainbowcol" .. i
          vim.cmd("highlight " .. color_name .. " gui=bold")
        end
        
        vim.notify("Enhanced CSV colors applied", vim.log.levels.INFO)
      end, {})
      
      -- Apply enhancements immediately after rainbow highlighting is applied
      vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = {"csv", "tsv"},
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
        end
      })
    end,
  }
}