vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- Set Python path for Neovim to use the venv
vim.g.python3_host_prog = vim.fn.expand('~/.config/nvim/venv/bin/python')

-- Disable providers you don't use to reduce warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2       -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2    -- 2 spaces for indent width
opt.expandtab = true  -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- enable syntax and filetype plugins
vim.opt.syntax = "on"
vim.cmd("filetype plugin indent on")

-- Set up filetype mappings for React files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.jsx" },
  callback = function()
    vim.bo.filetype = "javascriptreact"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tsx" },
  callback = function()
    vim.bo.filetype = "typescriptreact"
  end,
})

-- Ensure TreeSitter uses the correct parsers for React filetypes
vim.treesitter.language.register('javascript', 'javascriptreact')
vim.treesitter.language.register('tsx', 'typescriptreact')
