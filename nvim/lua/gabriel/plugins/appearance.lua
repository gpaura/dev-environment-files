-- Bold text and transparency in Neovim configuration
-- Consolidated to prevent conflicts and ensure transparency works

-- Shared module for bold and transparency that both colorschemes can use
local function setup_bold_and_transparency()
  local M = {}

  function M.apply()
    -- Get all highlight groups
    local highlight_groups = vim.fn.getcompletion("", "highlight")

    -- Apply bold to each highlight group
    for _, group in ipairs(highlight_groups) do
      -- Skip groups with 'Italic' in their name to preserve italic style
      if not string.find(group, "Italic") then
        local current = vim.api.nvim_get_hl(0, { name = group })
        if current and next(current) then
          -- Keep original settings, just add bold
          current.bold = true
          vim.api.nvim_set_hl(0, group, current)
        end
      end
    end

    -- Clear backgrounds for transparency after applying bold
    -- These are the critical ones for transparency to work
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
    vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
    vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
    vim.api.nvim_set_hl(0, "SpecialKey", { bg = "none" })
    vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" })
  end

  return M
end

return {
  -- Monokai Pro Filter Octagon Theme (DISABLED - dark theme)
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    lazy = false,
    enabled = false,
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

      -- Set the colorscheme
      vim.cmd.colorscheme("monokai-pro")

      -- Create and register the transparency module
      local transparency = setup_bold_and_transparency()
      package.loaded["transparency_manager"] = transparency

      -- Set up autocmd to reapply on colorscheme changes
      vim.api.nvim_create_augroup("TransparencyManager", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = "TransparencyManager",
        callback = function()
          -- Defer to ensure it runs after the colorscheme fully loads
          vim.defer_fn(function()
            transparency.apply()
          end, 10)
        end,
      })

      -- Apply immediately after colorscheme loads
      transparency.apply()

      -- Also apply after ALL plugins have loaded (belt and suspenders approach)
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          vim.defer_fn(function()
            transparency.apply()
          end, 50)
        end,
      })
    end,
  },

  -- Catppuccin Theme (DISABLED - light theme option)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = false, -- DISABLED
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

      -- Use the same transparency manager
      local transparency = setup_bold_and_transparency()
      package.loaded["transparency_manager"] = transparency

      vim.api.nvim_create_augroup("TransparencyManager", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = "TransparencyManager",
        callback = function()
          vim.defer_fn(function()
            transparency.apply()
          end, 10)
        end,
      })

      transparency.apply()
    end,
  },

  -- Ayu Theme Light (PRIMARY - light theme active)
  {
    "Shatur/neovim-ayu",
    priority = 1000,
    enabled = true,
    config = function()
      require("ayu").setup({
        mirage = false, -- Set to true for mirage variant
        terminal = true, -- Set to false if terminal theme doesn't need change
        overrides = {}, -- Add custom overrides here
      })

      -- Set to light variant
      vim.o.background = "light"
      vim.cmd.colorscheme("ayu-light")

      -- Use the same transparency manager
      local transparency = setup_bold_and_transparency()
      package.loaded["transparency_manager"] = transparency

      vim.api.nvim_create_augroup("TransparencyManager", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = "TransparencyManager",
        callback = function()
          vim.defer_fn(function()
            transparency.apply()
          end, 10)
        end,
      })

      transparency.apply()

      -- Apply after VimEnter for consistency
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          vim.defer_fn(function()
            transparency.apply()
          end, 50)
        end,
      })
    end,
  },

}
