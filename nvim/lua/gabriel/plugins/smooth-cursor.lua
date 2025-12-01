return {
  "gen740/SmoothCursor.nvim",
  config = function()
    require('smoothcursor').setup({
      autostart = true,
      cursor = "▷",
      type = "default",
      speed = 25,               -- Slower to reduce conflicts
      intervals = 50,           -- Less frequent updates
      threshold = 3,            -- Higher threshold
      priority = 5,             -- Lower priority than smear-cursor
      timeout = 1500,           -- Shorter timeout
      disable_float_win = true, -- Disable in floating windows
      disable_in_macro = true,  -- Disable during macros
      fancy = {
        enable = true,
        head = { cursor = "▷", texthl = "SmoothCursor" },
        body = {
          { cursor = "●", texthl = "SmoothCursorRed" },
          { cursor = "●", texthl = "SmoothCursorOrange" },
          { cursor = "•", texthl = "SmoothCursorYellow" },
          { cursor = "•", texthl = "SmoothCursorGreen" },
          { cursor = ".", texthl = "SmoothCursorBlue" },
        },
        tail = { cursor = nil, texthl = "SmoothCursor" }
      }
    })

    -- Set up the highlight colors
    vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#FF79C6' })
    vim.api.nvim_set_hl(0, 'SmoothCursorRed', { fg = '#FF5555' })
    vim.api.nvim_set_hl(0, 'SmoothCursorOrange', { fg = '#FFB86C' })
    vim.api.nvim_set_hl(0, 'SmoothCursorYellow', { fg = '#F1FA8C' })
    vim.api.nvim_set_hl(0, 'SmoothCursorGreen', { fg = '#50FA7B' })
    vim.api.nvim_set_hl(0, 'SmoothCursorBlue', { fg = '#8BE9FD' })
  end
}
