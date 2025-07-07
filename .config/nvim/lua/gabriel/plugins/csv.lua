-- ~/.config/nvim/lua/gabriel/plugins/csv.lua
return {
  {
    "mechatroner/rainbow_csv",
    lazy = false,
    config = function()
      -- Core configuration - keep it simple
      vim.g.disable_rainbow_csv_autodetect = 0  -- Enable autodetection (0 means enabled)
      vim.g.rcsv_max_columns = 50               -- Increase max columns for detection
      
      -- Disable conflicting CSV plugin settings
      vim.g.csv_autocmd_arrange = 0             -- Disable csv.vim auto-arrange
      vim.g.csv_no_conceal = 1                  -- Show separators
      vim.g.loaded_csv = 1                      -- Prevent csv.vim from loading
      
      -- Handle CSV files with proper rainbow_csv setup
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "*.csv", "*.dat", "*.tsv" },
        callback = function()
          if vim.bo.fileformat == "dos" then
            vim.bo.fileformat = "unix"
          end

          -- Force filetype to csv
          vim.bo.filetype = "csv"
          
          -- Let rainbow_csv handle the highlighting automatically
          vim.defer_fn(function()
            -- Rainbow CSV should auto-detect and highlight
            vim.cmd("set nomodified")
          end, 100)
        end,
      })

      -- Detect extensionless CSV files
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*",
        callback = function()
          local fname = vim.fn.expand("%:t")
          
          -- Skip files with extensions
          if fname == "" or fname:match("%..+$") then
            return
          end
          
          -- Check for CSV-like content
          local lines = vim.fn.getline(1, math.min(5, vim.fn.line("$")))
          local comma_count = 0
          local total_examined = 0
          
          for _, line in ipairs(lines) do
            if line and #line > 0 then
              total_examined = total_examined + 1
              comma_count = comma_count + select(2, line:gsub(",", ""))
            end
          end
          
          -- If it looks like CSV, set the filetype
          if total_examined > 0 and (comma_count / total_examined) >= 1 then
            vim.bo.filetype = "csv"
            vim.b.csv_delimiter = ","
            vim.notify("Detected CSV file", vim.log.levels.INFO)
          end
        end,
      })

      -- Keymaps for CSV files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "csv",
        callback = function()
          local opts = { buffer = true, silent = true }
          
          -- Navigation
          vim.keymap.set("n", "<leader>cr", function()
            if vim.fn.exists(":RainbowCellGoRight") > 0 then
              vim.cmd("RainbowCellGoRight")
            end
          end, vim.tbl_extend("force", opts, { desc = "Next cell" }))
          
          vim.keymap.set("n", "<leader>cl", function()
            if vim.fn.exists(":RainbowCellGoLeft") > 0 then
              vim.cmd("RainbowCellGoLeft")
            end
          end, vim.tbl_extend("force", opts, { desc = "Previous cell" }))
          
          -- Alignment
          vim.keymap.set("n", "<leader>ca", function()
            if vim.fn.exists(":RainbowAlign") > 0 then
              vim.cmd("RainbowAlign")
              vim.notify("CSV aligned", vim.log.levels.INFO)
            else
              vim.notify("RainbowAlign not available", vim.log.levels.WARN)
            end
          end, vim.tbl_extend("force", opts, { desc = "Align CSV" }))
          
          vim.keymap.set("n", "<leader>cna", function()
            if vim.fn.exists(":RainbowNoAlign") > 0 then
              vim.cmd("RainbowNoAlign")
              vim.notify("CSV alignment removed", vim.log.levels.INFO)
            else
              vim.notify("RainbowNoAlign not available", vim.log.levels.WARN)
            end
          end, vim.tbl_extend("force", opts, { desc = "Remove alignment" }))
          
          -- Magic alignment
          vim.keymap.set("n", "<leader>cm", function()
            if vim.fn.exists(":RainbowAlign") > 0 then
              vim.cmd("RainbowAlign")
              vim.notify("✨ Magic! CSV aligned", vim.log.levels.INFO)
            else
              vim.notify("RainbowAlign not available", vim.log.levels.WARN)
            end
          end, vim.tbl_extend("force", opts, { desc = "Magic alignment" }))
        end,
      })
    end,
  }
}