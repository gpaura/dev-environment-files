-- ~/.config/nvim/lua/gabriel/plugins/auto-session.lua
return {
  "rmagatti/auto-session",
  config = function()
    -- Fix sessionoptions as recommended
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore = false,  -- Updated parameter name
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },  -- Updated parameter name
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
  end,
}