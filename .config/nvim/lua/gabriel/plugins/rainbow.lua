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
        java = rainbow_delimiters.strategy["global"],
        c_sharp = rainbow_delimiters.strategy["global"],
        javascript = rainbow_delimiters.strategy["global"],
        typescript = rainbow_delimiters.strategy["global"],
        javascriptreact = rainbow_delimiters.strategy["global"],
        typescriptreact = rainbow_delimiters.strategy["global"],
        html = rainbow_delimiters.strategy["global"],
        css = rainbow_delimiters.strategy["global"],
        json = rainbow_delimiters.strategy["global"],
        yaml = rainbow_delimiters.strategy["global"],
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
        sql = "rainbow-delimiters",
        python = "rainbow-delimiters",
        java = "rainbow-delimiters",
        c_sharp = "rainbow-delimiters",
        javascript = "rainbow-delimiters",
        typescript = "rainbow-delimiters",
        javascriptreact = "rainbow-delimiters",
        typescriptreact = "rainbow-delimiters",
        html = "rainbow-delimiters",
        css = "rainbow-delimiters",
        json = "rainbow-delimiters",
        yaml = "rainbow-delimiters",
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

    -- Define BOLDER and more vibrant colors for light theme
    vim.cmd([[
      highlight RainbowDelimiterRed guifg=#D70000 gui=bold ctermfg=160 cterm=bold
      highlight RainbowDelimiterBlue guifg=#0550AE gui=bold ctermfg=25 cterm=bold
      highlight RainbowDelimiterPurple guifg=#8000FF gui=bold ctermfg=93 cterm=bold
      highlight RainbowDelimiterGreen guifg=#007F0E gui=bold ctermfg=28 cterm=bold
      highlight RainbowDelimiterOrange guifg=#FF5D00 gui=bold ctermfg=202 cterm=bold
      highlight RainbowDelimiterPink guifg=#F6019D gui=bold ctermfg=199 cterm=bold
      highlight RainbowDelimiterTeal guifg=#009FAA gui=bold ctermfg=37 cterm=bold
    ]])

    -- Add an autocmd to ensure colors are set properly when colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Reapply rainbow delimiter highlighting after theme change
        vim.cmd([[
          highlight RainbowDelimiterRed guifg=#D70000 gui=bold ctermfg=160 cterm=bold
          highlight RainbowDelimiterBlue guifg=#0550AE gui=bold ctermfg=25 cterm=bold
          highlight RainbowDelimiterPurple guifg=#8000FF gui=bold ctermfg=93 cterm=bold
          highlight RainbowDelimiterGreen guifg=#007F0E gui=bold ctermfg=28 cterm=bold
          highlight RainbowDelimiterOrange guifg=#FF5D00 gui=bold ctermfg=202 cterm=bold
          highlight RainbowDelimiterPink guifg=#F6019D gui=bold ctermfg=199 cterm=bold
          highlight RainbowDelimiterTeal guifg=#009FAA gui=bold ctermfg=37 cterm=bold
        ]])
      end,
    })
  end,
}
