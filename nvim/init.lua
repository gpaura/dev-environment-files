-- ~/.config/nvim/init.lua
-- Performance optimized configuration

vim.loader.enable() -- Enable Lua module cache for faster loading

-- Early performance settings
vim.g.loaded_csv = 1 -- Disable csv.vim plugin to prevent conflicts

-- Fix E35/E486 errors - initialize early and after session restore
pcall(vim.fn.setreg, '/', '')
vim.opt.hlsearch = false

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    pcall(vim.fn.setreg, '/', '')
    vim.opt.hlsearch = false
  end,
})

-- Disable bells
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.shortmess:append("I") -- Don't show intro message

-- Load core modules
require("gabriel.core")
require("gabriel.lazy")

-- ============================================================================
-- VISUAL ENHANCEMENTS - Advanced UI Settings
-- ============================================================================
-- Enable true color support
vim.opt.termguicolors = true

-- Enhanced transparency and blur effects
vim.opt.pumblend = 10        -- Popup menu transparency
vim.opt.winblend = 10        -- Floating window transparency

-- Better visual indicators
vim.opt.cursorline = true    -- Highlight current line
vim.opt.number = true        -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers

-- Enhanced scrolling and animation
vim.opt.scroll = 8           -- Smoother scrolling
vim.opt.scrolloff = 8        -- Keep lines above/below cursor
vim.opt.sidescrolloff = 8    -- Keep columns left/right of cursor

-- Better visual feedback
vim.opt.showmode = false     -- Hide mode indicator (using statusline)
vim.opt.showcmd = true       -- Show partial commands
vim.opt.ruler = true         -- Show cursor position

-- Enhanced search visuals
vim.opt.hlsearch = true      -- Highlight search results
vim.opt.incsearch = true     -- Incremental search
vim.opt.ignorecase = true    -- Case insensitive search
vim.opt.smartcase = true     -- Smart case sensitivity

-- Better indentation visualization
vim.opt.list = true          -- Show invisible characters
vim.opt.listchars = {
  tab = '→ ',
  trail = '·',
  extends = '»',
  precedes = '«',
  nbsp = '⚬'
}

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


