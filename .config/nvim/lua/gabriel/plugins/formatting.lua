return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- Register a custom formatter for CSV files
    conform.formatters.csv_formatter = {
      command = "column",
      args = { "-t", ",", "-s", "," },
    }

    -- Configure SQL formatter specifically for MSSQL (transactsql/tsql)
    conform.formatters.sql_formatter = {
      command = "sql-formatter",
      args = function(self, ctx)
        return {
          "-l",
          "tsql",
        }
      end,
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
        go = { "gofmt" },
        -- Use your custom formatter for CSV files
        csv = { "csv_formatter" },
        dat = { "csv_formatter" },
        toml = { "taplo" },
        sql = { "sql_formatter" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true, -- fallback to LSP formatting if no formatter is set
      },
    })

    -- Your keymap and other settings
  end,
}
