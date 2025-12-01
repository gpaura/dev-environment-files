return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- Use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/vaults/personal",
        },
      },
    },
  }