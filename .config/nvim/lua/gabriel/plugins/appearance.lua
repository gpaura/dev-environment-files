-- Bold text in Neovim configuration
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
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
        -- Force bold for syntax elements
        styles = {
          comments = { "bold" },
          conditionals = { "bold" },
          loops = { "bold" },
          functions = { "bold" },
          keywords = { "bold" },
          strings = { "bold" },
          variables = { "bold" },
          numbers = { "bold" },
          booleans = { "bold" },
          properties = { "bold" },
          types = { "bold" },
          operators = { "bold" },
        },
      })
      vim.cmd.colorscheme("catppuccin")

      -- Apply bold to all highlighting groups
      vim.cmd([[
        augroup BoldEverything
          autocmd!
          autocmd ColorScheme * lua require('bold_everything').apply_bold()
        augroup END
      ]])

      -- Create module for applying bold to all highlight groups
      local bold_everything = {}

      function bold_everything.apply_bold()
        -- Get all highlight groups
        local highlight_groups = vim.fn.getcompletion("", "highlight")

        -- Apply bold to each highlight group
        for _, group in ipairs(highlight_groups) do
          -- Skip groups with 'Italic' in their name to preserve italic style
          if not string.find(group, "Italic") then
            local current = vim.api.nvim_get_hl(0, { name = group })
            if current then
              -- Keep original settings, just add bold
              current.bold = true
              vim.api.nvim_set_hl(0, group, current)
            end
          end
        end
      end

      -- Make the module available
      package.loaded["bold_everything"] = bold_everything

      -- Apply bold to existing highlight groups
      bold_everything.apply_bold()
    end,
  },

  -- Add configuration for terminal appearance
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        -- Terminal configuration to ensure bold text
        highlights = {
          Normal = {
            bold = true,
          },
          NormalFloat = {
            bold = true,
          },
        },
      })

      -- Ensure terminal text is bold
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function()
          vim.opt.winhighlight = "Normal:Normal"
          vim.cmd("highlight! TermCursor cterm=bold gui=bold")
          vim.cmd("highlight! TermNormal cterm=bold gui=bold")
        end,
      })
    end,
  },
}
