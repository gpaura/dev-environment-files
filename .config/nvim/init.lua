-- ~/.config/nvim/init.lua
require("gabriel.core") -- Or however you load your core.lua
require("gabriel.lazy")

-- Function to close Neovim when closing the last tab
vim.api.nvim_create_user_command("SmartTabClose", function()
  if vim.fn.tabpagenr("$") == 1 then
    vim.cmd("quit")
  else
    vim.cmd("tabclose")
  end -- Changed from 'endif' to 'end'
end, {})

-- Create a key mapping for the smart tab close (optional)
-- You can change <leader>tc to any key combination you prefer
vim.keymap.set("n", "<leader>tc", ":SmartTabClose<CR>", { noremap = true, silent = true })

-- CSV settings
vim.g.csv_autocmd_arrange = 1 -- Autoajustar colunas ao abrir arquivos CSV
vim.g.csv_no_conceal = 1 -- Exibir separadores reais como vírgulas etc.

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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    local ok, colorizer = pcall(require, "colorizer")
    if ok then
      pcall(colorizer.attach_to_buffer, 0)
    end
  end,
})

-- Add this new autocmd to prevent formatting from counting as a change
vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  callback = function()
    -- Run after the formatting happens
    vim.defer_fn(function()
      -- Mark buffer as unmodified after auto-formatting
      vim.cmd("set nomodified")
    end, 100) -- Small delay to ensure it runs after formatting
  end,
})

-- Improved detection for extensionless CSV files
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    local fname = vim.fn.expand("%:t")

    -- Only process files without extensions
    if fname == "" or fname:match("%..+$") then
      return
    end

    -- Check first 10 lines for CSV patterns
    local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
    local comma_count = 0
    local examined = 0

    for _, line in ipairs(lines) do
      if line and #line > 0 then
        examined = examined + 1
        -- Count commas in the line
        comma_count = comma_count + select(2, line:gsub(",", ""))
      end
    end

    -- If we have a decent number of commas, it's likely a CSV
    if examined > 0 and (comma_count / examined) >= 2 then
      -- Set filetype to CSV
      vim.bo.filetype = "csv"
      vim.b.csv_delimiter = ","

      -- Apply rainbow highlighting with a slight delay to ensure filetype is applied
      vim.defer_fn(function()
        -- Try to find a comma for highlighting
        for i, line in ipairs(lines) do
          local comma_pos = string.find(line, ",")
          if comma_pos then
            -- Save cursor position
            local cursor_pos = vim.fn.getcurpos()
            -- Move to comma position
            vim.fn.cursor(i, comma_pos)
            -- Apply rainbow highlighting
            pcall(vim.cmd, "RainbowDelim")
            -- Restore cursor position
            vim.fn.setpos(".", cursor_pos)
            break
          end
        end

        -- Mark buffer as unmodified after formatting
        vim.cmd("set nomodified")
      end, 100)
    end
  end,
  group = vim.api.nvim_create_augroup("CSVExtensionless", { clear = true }),
})

-- Add to your init.lua to track startup time
vim.g.start_time = vim.loop.hrtime()
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.g.startuptime = (vim.loop.hrtime() - vim.g.start_time) / 1000000
  end,
})

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
