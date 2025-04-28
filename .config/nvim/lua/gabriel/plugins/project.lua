-- ~/.config/nvim/lua/gabriel/plugins/project.lua
return {
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        patterns = { ".git", "package.json", "requirements.txt", "Cargo.toml", "pyproject.toml", "go.mod" },
        detection_methods = { "pattern", "lsp" },
        show_hidden = false,
      })

      -- Integrate with telescope
      require("telescope").load_extension("projects")
      vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find projects" })
    end,
  },
}
