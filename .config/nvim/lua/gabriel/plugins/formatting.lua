return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- Register a custom formatter for CSV files
    conform.formatters.csv_formatter = {
      command = "column",
      args = {"-t", ",", "-s", ","}
    }

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        -- Use your custom formatter for CSV files
        csv = { "csv_formatter" },
      },
      -- Rest of your setup remains the same
    })
    
    -- Your keymap and other settings
  end,
}