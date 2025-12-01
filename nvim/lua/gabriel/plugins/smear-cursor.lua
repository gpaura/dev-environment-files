return {
  "sphamba/smear-cursor.nvim",
  config = function()
    require("smear_cursor").setup({
      -- Enhanced cursor effects with improved performance
      cursor_color = "#FF79C6", -- Match theme color
      normal_bg = "#1A1B26",

      -- Enhanced visual effects
      stiffness = 0.8,              -- Smoother movement
      trailing_stiffness = 0.5,     -- Better trailing effect
      distance_stop_animating = 0.5, -- Stop animation distance
      hide_target_hack = true,

      -- Improved buffer and line handling
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      legacy_computing_symbols_support = true,

      -- Performance optimizations
      max_slope = -1.5,             -- Improved curve calculation
      gamma = 2.2,                  -- Better color blending

      -- Reduce conflicts with other cursor plugins
      disable_on_popup = true,      -- Disable during popups/menus
      disable_in_insert = false,    -- Keep in insert mode
    })

    -- Set up gradient fire effect
    vim.api.nvim_set_hl(0, 'SmearCursor', {
      fg = '#FF4500', -- Orange-red
      bg = 'NONE',
      blend = 30
    })

    -- Optional: Set up additional fire highlights
    vim.api.nvim_set_hl(0, 'SmearCursorTrail', {
      fg = '#FF6B35', -- Lighter orange
      bg = 'NONE',
      blend = 60
    })
  end,
}
