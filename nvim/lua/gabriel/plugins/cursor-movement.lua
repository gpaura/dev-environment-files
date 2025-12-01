return {
  -- No plugin needed, just better cursor settings
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      -- Faster cursor updates for smoother movement
      vim.opt.updatetime = 50
      vim.opt.timeoutlen = 300

      -- Smooth cursor appearance
      vim.opt.guicursor = {
        "n-v-c-sm:block-Cursor/lCursor-blinkwait700-blinkon400-blinkoff400",
        "i-ci-ve:ver25-Cursor/lCursor-blinkwait700-blinkon400-blinkoff400",
        "r-cr-o:hor20-Cursor/lCursor-blinkwait700-blinkon400-blinkoff400",
      }

      -- Enable smooth scrolling
      vim.opt.smoothscroll = true
    end
  }
}
