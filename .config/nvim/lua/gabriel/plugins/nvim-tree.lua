return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  priority = 1000,
  config = function()
    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local nvimtree = require("nvim-tree")

    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = true,
        float = {
          enable = false,
          quit_on_focus_loss = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = 40,
            height = 30,
            row = 1,
            col = 1,
          },
        },
      },
      -- Enhanced renderer with better visuals
      renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = true,
        full_name = false,
        highlight_opened_files = "all",
        highlight_modified = "name",
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = "before",
          modified_placement = "after",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
          },
          glyphs = {
            default = "󰈚",
            symlink = "",
            bookmark = "󰆤",
            modified = "●",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
        dotfiles = false,
      },
      git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
        timeout = 400,
      },
      -- Enhanced diagnostics integration
      diagnostics = {
        enable = false,
      },
      -- Enhanced modified file tracking
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      -- Better tab integration
      tab = {
        sync = {
          open = true,
          close = true,
          ignore = {},
        },
      },
    })

    -- Set custom highlight groups for colored folders and icons
    vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#8AADF4" }) -- Blue folders
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = "#8AADF4" }) -- Blue open folders
    vim.api.nvim_set_hl(0, "NvimTreeClosedFolderIcon", { fg = "#8AADF4" }) -- Blue closed folders
    vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#CAD3F5" }) -- Light text for folder names
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#CAD3F5", bold = true }) -- Light bold for open folders
    vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = "#6E738D" }) -- Gray for empty folders
    vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#5B6078" }) -- Subtle indent markers
    vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = "#F5A97F", bold = true }) -- Orange for root

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
  end
}