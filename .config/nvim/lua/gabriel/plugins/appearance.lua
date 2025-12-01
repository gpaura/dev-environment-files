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

        -- Clear backgrounds for transparency after applying bold
        vim.api.nvim_set_hl(0, "Normal", { bg = "none", bold = true })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", bold = true })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none", bold = true })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
        vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
        vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
        vim.api.nvim_set_hl(0, "SpecialKey", { bg = "none" })
        vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
      end

      -- Make the module available
      package.loaded["bold_everything"] = bold_everything

      -- Apply bold to existing highlight groups
      bold_everything.apply_bold()
    end,
  },

  -- Monokai Pro Filter Octagon Theme
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
        terminal_colors = true,
        devicons = true,
        styles = {
          comment = { italic = true, bold = true },
          keyword = { italic = true, bold = true },
          type = { italic = true, bold = true },
          storageclass = { italic = true, bold = true },
          structure = { italic = true, bold = true },
          parameter = { italic = true, bold = true },
          annotation = { italic = true, bold = true },
          tag_attribute = { italic = true, bold = true },
        },
        filter = "octagon", -- Filter octagon variant
        inc_search = "background",
        background_clear = {
          "nvim-tree",
          "neo-tree",
          "bufferline",
          "telescope",
          "which-key",
          "notify",
          "noice",
        },
        plugins = {
          bufferline = {
            underline_selected = false,
            underline_visible = false,
          },
          indent_blankline = {
            context_highlight = "default",
            context_start_underline = false,
          },
        },
      })

      -- Uncomment the line below to use Monokai Pro instead of Catppuccin
      vim.cmd.colorscheme("monokai-pro")

      -- Apply bold to all highlighting groups (same as Catppuccin)
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

        -- Clear backgrounds for transparency after applying bold
        vim.api.nvim_set_hl(0, "Normal", { bg = "none", bold = true })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", bold = true })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none", bold = true })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
        vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
        vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
        vim.api.nvim_set_hl(0, "SpecialKey", { bg = "none" })
        vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
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
