return {
  {
    "mechatroner/rainbow_csv",
    lazy = false,
    config = function()
      -- Handle Windows-style line endings in CSV files
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "*.csv", "*.dat" },
        callback = function()
          if vim.bo.fileformat == "dos" then
            vim.notify("Converting Windows line endings for CSV highlighting", vim.log.levels.INFO)
            vim.bo.fileformat = "unix"
          end

          -- Force filetype in case it's not set properly
          vim.cmd("set ft=csv")
          vim.cmd("RainbowDelim ,")
        end,
      })

      -- Keymaps for CSV navigation
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "csv" },
        callback = function()
          vim.keymap.set("n", "<leader>cr", ":RainbowCellGoRight<CR>", { buffer = true, desc = "Next cell" })
          vim.keymap.set("n", "<leader>cl", ":RainbowCellGoLeft<CR>", { buffer = true, desc = "Previous cell" })
        end,
      })

      -- Set filetype=csv for extensionless files with commas
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*",
        callback = function()
          local fname = vim.fn.expand("%:t")
          if fname ~= "" and not fname:match("%..+$") then
            local first_line = vim.fn.getline(1)
            if first_line:find(",") then
              vim.bo.filetype = "csv"
            end
          end
        end,
      })
    end,
  },
}
