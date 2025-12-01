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
              default = "󰉋",
              open = "󰝰",
              empty = "󰉖",
              empty_open = "󰷏",
              symlink = "󰉒",
              symlink_open = "󰉓",
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
        custom = { ".DS_Store", "lazy-lock.json" },
        dotfiles = false,
        exclude = {},
      },
      git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
        timeout = 400,
      },
      -- Filesystem watchers configuration
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {
          "node_modules",
          ".git",
          "target",
          "build",
          "dist",
          ".cache",
          ".local/share/nvim/lazy",
          ".local/state/nvim",
        },
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
    -- Monokai Pro Octagon color palette
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" }) -- Transparent background
    vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" }) -- Transparent background for non-current
    vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" }) -- Transparent end of buffer
    vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = "none" }) -- Transparent vertical split
    vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#FFD866" }) -- Yellow folders (Monokai yellow)
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = "#FF6188" }) -- Pink open folders (Monokai pink)
    vim.api.nvim_set_hl(0, "NvimTreeClosedFolderIcon", { fg = "#FFD866" }) -- Yellow closed folders
    vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#FCFCFA" }) -- White text for folder names
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#FF6188", bold = true }) -- Pink bold for open folders
    vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = "#727072" }) -- Gray for empty folders
    vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#5B595C" }) -- Subtle indent markers
    vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = "#FC9867", bold = true }) -- Orange for root (Monokai orange)

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
  end
}