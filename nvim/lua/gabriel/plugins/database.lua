-- ~/.config/nvim/lua/gabriel/plugins/database.lua
-- Enhanced database management similar to SSMS

return {
  -- Core database plugin
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection" },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB Buffer" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename DB Buffer" },
      { "<leader>dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
    },
    config = function()
      -- Database UI Configuration
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_messages = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 40
      
      -- Auto-execute queries (similar to SSMS F5)
      vim.g.db_ui_auto_execute_table_helpers = 1
      
      -- SQL formatting and execution settings
      vim.g.db_ui_execute_on_save = 0  -- Don't auto-execute on save
      vim.g.db_ui_use_nvim_notify = 1  -- Use notifications for results
      
      -- Default connections (you can modify these)
      vim.g.dbs = {
        -- Example connections - modify these for your databases
        {
          name = "local_postgres",
          url = "postgres://username:password@localhost:5432/database_name"
        },
        {
          name = "local_mysql",
          url = "mysql://username:password@localhost:3306/database_name"
        },
        {
          name = "local_sqlite",
          url = "sqlite:" .. vim.fn.expand("~/dev/database.sqlite")
        },
        -- SQL Server example (you'll need the right driver)
        {
          name = "sqlserver_dev",
          url = "sqlserver://username:password@server:1433/database_name"
        }
      }

      -- Enhanced SQL completion setup
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql", "tsql" },
        callback = function()
          -- Set up completion sources for SQL files
          require("cmp").setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
              { name = "path" }
            }
          })
          
          -- SQL-specific keymaps (similar to SSMS shortcuts)
          local opts = { buffer = true, silent = true }
          
          -- F5 - Execute query (like SSMS)
          vim.keymap.set("n", "<F5>", "<cmd>DB<cr>", 
            vim.tbl_extend("force", opts, { desc = "Execute SQL query" }))
          vim.keymap.set("v", "<F5>", ":<C-u>'<,'>DB<cr>", 
            vim.tbl_extend("force", opts, { desc = "Execute selected SQL" }))
          
          -- Ctrl+R - Execute query under cursor
          vim.keymap.set("n", "<C-r>", "<cmd>DB<cr>", 
            vim.tbl_extend("force", opts, { desc = "Execute current query" }))
          
          -- Enhanced SQL editing shortcuts
          vim.keymap.set("n", "<leader>se", "<cmd>DB<cr>", 
            vim.tbl_extend("force", opts, { desc = "Execute SQL" }))
          vim.keymap.set("v", "<leader>se", ":<C-u>'<,'>DB<cr>", 
            vim.tbl_extend("force", opts, { desc = "Execute selected SQL" }))
          vim.keymap.set("n", "<leader>st", "<cmd>DBUIToggle<cr>", 
            vim.tbl_extend("force", opts, { desc = "Toggle DB UI" }))
          vim.keymap.set("n", "<leader>sf", "<cmd>lua require('telescope.builtin').live_grep({search_dirs={'~/db_queries'}})<cr>", 
            vim.tbl_extend("force", opts, { desc = "Find in SQL files" }))
        end,
      })

      -- Auto-detect SQL file types and set up proper highlighting
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.sql", "*.SQL" },
        callback = function()
          vim.bo.filetype = "sql"
          vim.bo.commentstring = "-- %s"
        end,
      })

      -- Create SQL snippet directory if it doesn't exist
      local sql_snippets_dir = vim.fn.stdpath("data") .. "/sql_snippets"
      if vim.fn.isdirectory(sql_snippets_dir) == 0 then
        vim.fn.mkdir(sql_snippets_dir, "p")
      end

      -- Helper function to create new SQL query file
      vim.api.nvim_create_user_command("NewSQLQuery", function(opts)
        local filename = opts.args
        if filename == "" then
          filename = "query_" .. os.date("%Y%m%d_%H%M%S") .. ".sql"
        elseif not filename:match("%.sql$") then
          filename = filename .. ".sql"
        end
        
        local filepath = sql_snippets_dir .. "/" .. filename
        vim.cmd("edit " .. filepath)
        vim.bo.filetype = "sql"
        
        -- Insert basic SQL template
        local template = {
          "-- SQL Query: " .. filename,
          "-- Created: " .. os.date("%Y-%m-%d %H:%M:%S"),
          "-- Database: [CONNECTION_NAME]",
          "",
          "-- Write your SQL query here:",
          "SELECT ",
          "FROM ",
          "WHERE ",
          ""
        }
        vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
        vim.api.nvim_win_set_cursor(0, {5, 7}) -- Position cursor after SELECT
      end, { nargs = "?", complete = "file", desc = "Create new SQL query file" })

      -- SQL formatting command (requires sql-formatter to be installed)
      vim.api.nvim_create_user_command("FormatSQL", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local sql_content = table.concat(lines, "\n")
        
        -- You can use sql-formatter or any other SQL formatter
        -- Install: npm install -g sql-formatter
        local formatted = vim.fn.system("sql-formatter --language=tsql", sql_content)
        
        if vim.v.shell_error == 0 then
          local formatted_lines = vim.split(formatted, "\n")
          vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted_lines)
          vim.notify("SQL formatted successfully", vim.log.levels.INFO)
        else
          vim.notify("SQL formatting failed. Install sql-formatter: npm install -g sql-formatter", vim.log.levels.WARN)
        end
      end, { desc = "Format SQL code" })
    end,
  },

  -- Additional SQL tools
  {
    "nanotee/sqls.nvim",
    ft = { "sql" },
    config = function()
      require("sqls").on_attach(function(client, bufnr)
        -- SQL LSP keymaps
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "<leader>scc", "<cmd>SqlsExecuteQuery<cr>", 
          vim.tbl_extend("force", opts, { desc = "Execute query with sqls" }))
        vim.keymap.set("v", "<leader>scc", "<cmd>SqlsExecuteQueryVertical<cr>", 
          vim.tbl_extend("force", opts, { desc = "Execute selection with sqls" }))
        vim.keymap.set("n", "<leader>scd", "<cmd>SqlsShowDatabases<cr>", 
          vim.tbl_extend("force", opts, { desc = "Show databases" }))
        vim.keymap.set("n", "<leader>scs", "<cmd>SqlsShowSchemas<cr>", 
          vim.tbl_extend("force", opts, { desc = "Show schemas" }))
        vim.keymap.set("n", "<leader>sct", "<cmd>SqlsShowTables<cr>", 
          vim.tbl_extend("force", opts, { desc = "Show tables" }))
      end)
    end,
  },

  -- HTTP client for REST APIs (useful for API database interactions)
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "http" },
    keys = {
      { "<leader>rr", "<Plug>RestNvim", desc = "Run HTTP request" },
      { "<leader>rp", "<Plug>RestNvimPreview", desc = "Preview HTTP request" },
    },
    config = function()
      require("rest-nvim").setup({
        result_split_horizontal = false,
        result_split_in_place = false,
        skip_ssl_verification = false,
        highlight = {
          enabled = true,
          timeout = 150,
        },
      })
    end,
  }
}