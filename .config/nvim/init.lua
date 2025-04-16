-- ~/.config/nvim/init.lua
require("gabriel.core") -- Or however you load your core.lua
require("gabriel.lazy")

-- CSV settings
vim.g.csv_autocmd_arrange = 1 -- Autoajustar colunas ao abrir arquivos CSV
vim.g.csv_no_conceal = 1      -- Exibir separadores reais como vírgulas etc.

-- Create a more robust method for dealing with CSV files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  callback = function()
    -- Set CSV delimiter locally to ensure proper formatting
    vim.b.csv_delimiter = ","
    
    -- Try to arrange columns with ArrangeColumn command if available
    pcall(function()
      if vim.fn.exists(":ArrangeColumn") > 0 then
        vim.cmd("ArrangeColumn")
      end
    end)
  end,
})