-- ~/.config/nvim/lua/gabriel/plugins/terminal.lua
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      -- Basic keymaps
      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():append()
      end, { desc = "Add file to harpoon" })
      vim.keymap.set("n", "<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Show harpoon menu" })

      -- Navigation
      vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon file 4" })

      -- Terminal
      vim.keymap.set("n", "<leader>ht", function()
        harpoon.term.gotoTerminal(1)
      end, { desc = "Go to terminal 1" })
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", ":ZenMode<CR>", desc = "Toggle zen mode" },
    },
    opts = {
      window = {
        width = 90,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
        },
      },
      plugins = {
        tmux = { enabled = true },
        gitsigns = { enabled = false },
      },
    },
  },
}
