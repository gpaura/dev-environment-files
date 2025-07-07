-- ~/.config/nvim/lua/gabriel/plugins/csv.lua
-- Updated to work with perfect Magic command in init.lua
return {
  {
    "mechatroner/rainbow_csv",
    lazy = false,
    config = function()
      -- Core configuration - keep it simple
      vim.g.disable_rainbow_csv_autodetect = 0  -- Enable autodetection (0 means enabled)
      vim.g.rcsv_max_columns = 50               -- Increase max columns for detection
      
      -- No auto-alignment - Magic command in init.lua handles this perfectly
      local auto_align = false  -- Always false - Magic command handles alignment
      
      -- Handle Windows-style line endings in CSV files
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "*.csv", "*.dat", "*.tsv" },
        callback = function()
          if vim.bo.fileformat == "dos" then
            vim.notify("Converting Windows line endings for CSV highlighting", vim.log.levels.INFO)
            vim.bo.fileformat = "unix"
          end

          -- Force filetype in case it's not set properly
          vim.cmd("set ft=csv")
          
          -- Read the first line to find a comma for delimiter detection
          local first_line = vim.fn.getline(1)
          local comma_pos = string.find(first_line, ",")
          
          if comma_pos then
            -- Move cursor to the comma position, apply highlighting, then restore cursor
            local cursor_pos = vim.fn.getcurpos()
            vim.fn.cursor(1, comma_pos)
            vim.cmd("RainbowDelim")
            vim.fn.setpos(".", cursor_pos)
            
            -- NO automatic alignment - only colorization
            -- Use Magic command for alignment
          else
            -- Fallback to simple delimiter detection without cursor movement
            vim.cmd("RainbowDelimSimple")
          end
        end,
      })

      -- Detect and set CSV filetype for extensionless files with comma-delimited content
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*",
        callback = function()
          local fname = vim.fn.expand("%:t")
          
          -- Skip files with extensions or empty buffers
          if fname == "" or fname:match("%..+$") then
            return
          end
          
          -- Read the first few lines to check for CSV-like content
          local lines = vim.fn.getline(1, math.min(5, vim.fn.line("$")))
          
          -- Count commas in the first few lines to determine if it's likely a CSV
          local comma_count = 0
          local total_examined = 0
          
          for _, line in ipairs(lines) do
            if line and line:len() > 0 then
              total_examined = total_examined + 1
              comma_count = comma_count + select(2, line:gsub(",", ""))
            end
          end
          
          -- Heuristic: If we have commas in most lines, it's likely a CSV file
          if total_examined > 0 and (comma_count / total_examined) >= 1 then
            vim.bo.filetype = "csv"
            vim.notify("Detected comma-delimited file. Setting filetype to CSV.", vim.log.levels.INFO)
            
            -- Apply basic CSV settings for extensionless files
            vim.b.csv_delimiter = ","
            
            -- Find first comma and use it for rainbow highlighting ONLY
            for i, line in ipairs(lines) do
              local comma_pos = string.find(line, ",")
              if comma_pos then
                -- Save cursor position
                local cursor_pos = vim.fn.getcurpos()
                -- Move to comma position
                vim.fn.cursor(i, comma_pos)
                -- Apply rainbow highlighting ONLY
                vim.cmd("RainbowDelim")
                -- Restore cursor position
                vim.fn.setpos(".", cursor_pos)
                
                -- NO automatic alignment - only colorization
                -- Use Magic command for alignment
                break
              end
            end
          end
        end,
      })

      -- NOTE: Magic and Unmagic commands are now defined in init.lua with perfect mechanism
      -- No need to duplicate them here

      -- Keymaps for CSV navigation
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "csv" },
        callback = function()
          -- CSV navigation
          vim.keymap.set("n", "<leader>cr", ":RainbowCellGoRight<CR>", { buffer = true, desc = "Next cell" })
          vim.keymap.set("n", "<leader>cl", ":RainbowCellGoLeft<CR>", { buffer = true, desc = "Previous cell" })
          vim.keymap.set("n", "<leader>cu", ":RainbowCellGoUp<CR>", { buffer = true, desc = "Cell above" })
          vim.keymap.set("n", "<leader>cd", ":RainbowCellGoDown<CR>", { buffer = true, desc = "Cell below" })
          
          -- Magic alignment command (defined in init.lua)
          vim.keymap.set("n", "<leader>cm", ":Magic<CR>", { buffer = true, desc = "Magic CSV alignment (perfect)" })
          
          -- Manual alignment using RainbowAlign (less perfect)
          vim.keymap.set("n", "<leader>ca", ":RainbowAlign<CR>", { buffer = true, desc = "Align CSV columns (basic)" })
          
          -- Remove alignment
          vim.keymap.set("n", "<leader>cn", ":Unmagic<CR>", { buffer = true, desc = "Remove CSV alignment" })
          
          -- Other CSV operations
          vim.keymap.set("n", "<leader>cs", ":RainbowSortCSV<CR>", { buffer = true, desc = "Sort CSV by column" })
          
          -- Reapply highlighting if needed with proper cursor positioning
          vim.keymap.set("n", "<leader>ch", function()
            -- Find a comma in the current line
            local line = vim.fn.getline(".")
            local comma_pos = string.find(line, ",")
            
            if comma_pos then
              -- Save cursor position
              local cursor_pos = vim.fn.getcurpos()
              -- Move to comma position
              vim.fn.cursor(cursor_pos[2], comma_pos)
              -- Apply rainbow highlighting
              vim.cmd("RainbowDelim")
              -- Restore cursor position
              vim.fn.setpos(".", cursor_pos)
            else
              -- Try to find a comma in any line
              local lines = vim.fn.getline(1, vim.fn.line("$"))
              for i, l in ipairs(lines) do
                comma_pos = string.find(l, ",")
                if comma_pos then
                  -- Save cursor position
                  local cursor_pos = vim.fn.getcurpos()
                  -- Move to comma position
                  vim.fn.cursor(i, comma_pos)
                  -- Apply rainbow highlighting
                  vim.cmd("RainbowDelim")
                  -- Restore cursor position
                  vim.fn.setpos(".", cursor_pos)
                  break
                end
              end
            end
          end, { buffer = true, desc = "Reapply CSV highlighting" })
        end,
      })

      -- Create a helper command to reapply highlighting
      vim.api.nvim_create_user_command("ReapplyRainbow", function()
        -- Find a comma in any line
        local lines = vim.fn.getline(1, vim.fn.line("$"))
        for i, line in ipairs(lines) do
          local comma_pos = string.find(line, ",")
          if comma_pos then
            -- Save cursor position
            local cursor_pos = vim.fn.getcurpos()
            -- Move to comma position
            vim.fn.cursor(i, comma_pos)
            -- Apply rainbow highlighting
            vim.cmd("RainbowDelim")
            -- Restore cursor position
            vim.fn.setpos(".", cursor_pos)
            break
          end
        end
      end, {})

      -- Info command about Magic
      vim.api.nvim_create_user_command("MagicInfo", function()
        vim.notify("💡 Magic command uses perfect built-in CSV mechanism", vim.log.levels.INFO)
        vim.notify("📍 Magic is defined in init.lua, not csv.lua", vim.log.levels.INFO)
        vim.notify("🎯 Use :Magic for perfect alignment, :Unmagic to remove", vim.log.levels.INFO)
        vim.notify("⚡ <leader>cm also triggers Magic command", vim.log.levels.INFO)
      end, { desc = "Show info about Magic command" })
    end,
  }
}