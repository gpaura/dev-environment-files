-- ~/.config/nvim/lua/gabriel/plugins/rainbow.lua
return {
  "HiPhish/rainbow-delimiters.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
        sql = rainbow_delimiters.strategy["global"],
        python = rainbow_delimiters.strategy["global"],
        javascript = rainbow_delimiters.strategy["global"],
        typescript = rainbow_delimiters.strategy["global"],
        tsx = rainbow_delimiters.strategy["global"],
        html = rainbow_delimiters.strategy["global"],
        css = rainbow_delimiters.strategy["global"],
        json = rainbow_delimiters.strategy["global"],
        yaml = rainbow_delimiters.strategy["global"],
        c_sharp = rainbow_delimiters.strategy["global"],
        java = rainbow_delimiters.strategy["global"],
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
        sql = "rainbow-delimiters",
        python = "rainbow-delimiters",
        javascript = "rainbow-delimiters",
        typescript = "rainbow-delimiters",
        tsx = "rainbow-delimiters",
        html = "rainbow-delimiters",
        css = "rainbow-delimiters",
        json = "rainbow-delimiters",
        yaml = "rainbow-delimiters",
        c_sharp = "rainbow-delimiters",
        java = "rainbow-delimiters",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterBlue", 
        "RainbowDelimiterPurple",
        "RainbowDelimiterGreen",
        "RainbowDelimiterOrange",
        "RainbowDelimiterPink",
        "RainbowDelimiterTeal",
      },
    }

    -- Define colors with fallback for missing colorscheme
    vim.cmd([[
      highlight! default RainbowDelimiterRed guifg=#D70000 gui=bold ctermfg=160 cterm=bold
      highlight! default RainbowDelimiterBlue guifg=#0550AE gui=bold ctermfg=25 cterm=bold
      highlight! default RainbowDelimiterPurple guifg=#8000FF gui=bold ctermfg=93 cterm=bold
      highlight! default RainbowDelimiterGreen guifg=#007F0E gui=bold ctermfg=28 cterm=bold
      highlight! default RainbowDelimiterOrange guifg=#FF5D00 gui=bold ctermfg=202 cterm=bold
      highlight! default RainbowDelimiterPink guifg=#F6019D gui=bold ctermfg=199 cterm=bold
      highlight! default RainbowDelimiterTeal guifg=#009FAA gui=bold ctermfg=37 cterm=bold
    ]])

    -- Reapply colors after colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.cmd([[
          highlight! RainbowDelimiterRed guifg=#D70000 gui=bold ctermfg=160 cterm=bold
          highlight! RainbowDelimiterBlue guifg=#0550AE gui=bold ctermfg=25 cterm=bold
          highlight! RainbowDelimiterPurple guifg=#8000FF gui=bold ctermfg=93 cterm=bold
          highlight! RainbowDelimiterGreen guifg=#007F0E gui=bold ctermfg=28 cterm=bold
          highlight! RainbowDelimiterOrange guifg=#FF5D00 gui=bold ctermfg=202 cterm=bold
          highlight! RainbowDelimiterPink guifg=#F6019D gui=bold ctermfg=199 cterm=bold
          highlight! RainbowDelimiterTeal guifg=#009FAA gui=bold ctermfg=37 cterm=bold
        ]])
      end,
    })
  end,
}