-- ~/.config/nvim/init.lua
-- Performance optimized configuration

vim.loader.enable() -- Enable Lua module cache for faster loading

-- Early performance settings
vim.g.loaded_csv = 1 -- Disable csv.vim plugin to prevent conflicts

-- Load core modules
require("gabriel.core")
require("gabriel.lazy")

-- Utility functions (moved to local scope)
local function trim(s)
  return s and s:match("^%s*(.-)%s*$") or s
end

-- Smart tab close command
vim.api.nvim_create_user_command("SmartTabClose", function()
  if vim.fn.tabpagenr("$") == 1 then
    vim.cmd("quit")
  else
    vim.cmd("tabclose")
  end
end, {})

vim.keymap.set("n", "<leader>tc", ":SmartTabClose<CR>", { noremap = true, silent = true })

-- Optimized colorizer loading - only for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css", "scss", "html", "javascript", "typescript", "vue", "svelte" },
  callback = function()
    local ok, colorizer = pcall(require, "colorizer")
    if ok then
      pcall(colorizer.attach_to_buffer, 0)
    end
  end,
})

-- Lazy load CSV enhanced features when needed
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "tsv", "dat" },
  once = true,
  callback = function()
    require("gabriel.plugins.csv-enhanced")
    require("gabriel.plugins.csv-tools")
  end,
})

-- Optimized auto-detect for CSV files (only check specific extensions)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.dat", "*.txt" },
  callback = function()
    vim.defer_fn(function()
      if vim.bo.filetype == "" then
        local lines = vim.api.nvim_buf_get_lines(0, 0, math.min(3, vim.fn.line("$")), false)
        for _, line in ipairs(lines) do
          if line:match("[,;|\t].*[,;|\t]") then
            vim.bo.filetype = "csv"
            break
          end
        end
      end
    end, 100)
  end,
})



-- Track startup time for performance monitoring
vim.g.start_time = vim.loop.hrtime()
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.g.startuptime = (vim.loop.hrtime() - vim.g.start_time) / 1000000
    if vim.g.startuptime > 100 then
      vim.notify(string.format("Slow startup detected: %.1fms", vim.g.startuptime), vim.log.levels.WARN)
    end
  end,
})


