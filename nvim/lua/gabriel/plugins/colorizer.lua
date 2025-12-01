return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      "*", -- Apply to all filetypes
      css = {
        names = true, -- Enable named colors like 'red', 'blue'
        css = true,
        css_fn = true,
        mode = "background", -- Colorize background
      },
      lua = {
        names = true,
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
      },
    }, {
      mode = "background", -- Default mode globally
      names = true, -- Named colors like 'green'
      tailwind = true, -- Tailwind support (requires color names)
    })
    
    -- Auto-attach to all buffers
    vim.cmd("ColorizerAttachToBuffer")
  end,
}
