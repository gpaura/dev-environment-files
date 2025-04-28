-- ~/.config/nvim/lua/gabriel/plugins/colorscheme.lua
-- Theme configuration

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false, -- Load immediately
    config = function()
      require("catppuccin").setup({
        flavour = "latte", -- latte, frappe, macchiato, mocha
        transparent_background = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = true,
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },
}

-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   priority = 1000,
--   config = function()
--     local transparent = false

--     local bg = "#011628"
--     local bg_dark = "#011423"
--     local bg_highlight = "#143652"
--     local bg_search = "#0A64AC"
--     local bg_visual = "#275378"
--     local fg = "#CBE0F0"
--     local fg_dark = "#B4D0E9"
--     local fg_gutter = "#627E97"
--     local border = "#547998"

--     require("catppuccin").setup({
--       flavour = "mocha", -- latte, frappe, macchiato, mocha
--       transparent_background = transparent,
--       color_overrides = {
--         mocha = {
--           base = bg,
--           mantle = bg_dark,
--           crust = bg_dark,
--           surface0 = bg_highlight,
--           surface1 = bg_dark,
--           surface2 = bg_highlight,
--           text = fg,
--           subtext1 = fg_dark,
--           subtext0 = fg_gutter,
--           overlay2 = fg_gutter,
--           overlay1 = fg_dark,
--           overlay0 = fg_dark,
--           blue = bg_search,
--           lavender = fg,
--         },
--       },
--       highlight_overrides = {
--         mocha = function(colors)
--           return {
--             Normal = { bg = transparent and "NONE" or colors.base },
--             NormalFloat = { bg = transparent and "NONE" or colors.mantle },
--             FloatBorder = { fg = border, bg = transparent and "NONE" or colors.mantle },
--             Visual = { bg = bg_visual },
--             Search = { bg = bg_search },
--             StatusLine = { bg = transparent and "NONE" or colors.mantle },
--             LineNr = { fg = fg_gutter },
--             -- Add more highlight tweaks here as needed
--           }
--         end,
--       },
--       integrations = {
--         cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         treesitter = true,
--         telescope = {
--           enabled = true,
--         },
--       },
--     })

--     vim.cmd("colorscheme catppuccin")
--   end,
-- }


-- return {
--   "folke/tokyonight.nvim",
--   priority = 1000,
--   config = function()
--     local transparent = false -- set to true if you would like to enable transparency

--     local bg = "#011628"
--     local bg_dark = "#011423"
--     local bg_highlight = "#143652"
--     local bg_search = "#0A64AC"
--     local bg_visual = "#275378"
--     local fg = "#CBE0F0"
--     local fg_dark = "#B4D0E9"
--     local fg_gutter = "#627E97"
--     local border = "#547998"

--     require("tokyonight").setup({
--       style = "night",
--       transparent = transparent,
--       styles = {
--         sidebars = transparent and "transparent" or "dark",
--         floats = transparent and "transparent" or "dark",
--       },
--       on_colors = function(colors)
--         colors.bg = bg
--         colors.bg_dark = transparent and colors.none or bg_dark
--         colors.bg_float = transparent and colors.none or bg_dark
--         colors.bg_highlight = bg_highlight
--         colors.bg_popup = bg_dark
--         colors.bg_search = bg_search
--         colors.bg_sidebar = transparent and colors.none or bg_dark
--         colors.bg_statusline = transparent and colors.none or bg_dark
--         colors.bg_visual = bg_visual
--         colors.border = border
--         colors.fg = fg
--         colors.fg_dark = fg_dark
--         colors.fg_float = fg
--         colors.fg_gutter = fg_gutter
--         colors.fg_sidebar = fg_dark
--       end,
--     })

--     vim.cmd("colorscheme tokyonight")
--   end,
-- }
