return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Cache frames and highlights for better performance
    local frames = {
      {
        " ",
        " ███╗   ██╗███████╗ ██████╗  ",
        " ████╗  ██║██╔════╝██╔═══██╗ ",
        " ██╔██╗ ██║█████╗  ██║   ██║ ",
        " ██║╚██╗██║██╔══╝  ██║   ██║ ",
        " ██║ ╚████║███████╗╚██████╔╝ ",
        " ╚═╝  ╚═══╝╚══════╝ ╚═════╝  ",
        " ",
      },
      {
        " ",
        " ██╗   ██╗██╗███╗   ███╗ ",
        " ██║   ██║██║████╗ ████║ ",
        " ██║   ██║██║██╔████╔██║ ",
        " ╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        " ",
      },
      {
        " ",
        " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        " ",
      },
    }

    -- Pre-define highlight groups once
    local highlights = {
      { name = "AlphaHeader1", fg = "#61afef", bold = true },
      { name = "AlphaHeader2", fg = "#ff69b4", bold = true },
      { name = "AlphaHeader3", fg = "#b267e6", bold = true },
      { name = "AlphaButtonIcon1", fg = "#61afef" },
      { name = "AlphaButtonIcon2", fg = "#ff69b4" },
      { name = "AlphaButtonIcon3", fg = "#b267e6" },
    }

    -- Set all highlights at once
    for _, hl in ipairs(highlights) do
      vim.api.nvim_set_hl(0, hl.name, { fg = hl.fg, bold = hl.bold })
    end

    -- Cache button data for faster updates
    local button_configs = {
      { shortcut = "e", icon = "", label = "New file", cmd = "<cmd>ene<cr>" },
      { shortcut = "SPC ee", icon = "", label = "Toggle file explorer", cmd = "<cmd>NvimTreeToggle<cr>" },
      { shortcut = "SPC ff", icon = "󰱼", label = "Find file", cmd = "<cmd>Telescope find_files<cr>" },
      { shortcut = "SPC fs", icon = "", label = "Find word", cmd = "<cmd>Telescope live_grep<cr>" },
      { shortcut = "SPC wr", icon = "󰁯", label = "Restore session", cmd = "<cmd>SessionRestore<cr>" },
      { shortcut = "q", icon = "", label = "Quit Neovim", cmd = "<cmd>qa<cr>" },
    }

    -- Pre-calculate icon lengths for performance
    for _, config in ipairs(button_configs) do
      config.icon_len = vim.fn.strchars(config.icon)
    end

    -- Create buttons efficiently
    local function create_button(config)
      local txt = config.icon .. "  " .. config.label
      local button = dashboard.button(config.shortcut, txt, config.cmd)
      button.opts.hl = {{ "AlphaButtonIcon1", 0, config.icon_len }}
      button.opts.hl_shortcut = "AlphaHeader1"
      return button
    end

    -- Initialize dashboard
    dashboard.section.header.val = frames[1]
    dashboard.section.header.opts.hl = "AlphaHeader1"
    
    dashboard.section.buttons.val = {}
    for _, config in ipairs(button_configs) do
      table.insert(dashboard.section.buttons.val, create_button(config))
    end

    dashboard.section.footer.val = function()
      local stats = require("lazy").stats()
      local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
      return string.format("⚡ Neovim loaded %d/%d plugins in %.2f ms", stats.loaded, stats.count, ms)
    end

    dashboard.section.footer.opts.hl = "AlphaHeader1"

    -- Setup Alpha
    alpha.setup(dashboard.opts)

    -- Disable folding efficiently
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.foldenable = false
      end,
    })

    -- Smart animation with timer management
    local current_frame = 1
    local timer = nil
    local is_animating = false

    local function animate()
      if vim.bo.filetype ~= "alpha" or is_animating then
        return
      end
      
      is_animating = true

      -- Batch updates for better performance
      dashboard.section.header.val = frames[current_frame]
      dashboard.section.header.opts.hl = "AlphaHeader" .. current_frame
      dashboard.section.footer.opts.hl = "AlphaHeader" .. current_frame

      -- Update all buttons at once
      local hl_name = "AlphaButtonIcon" .. current_frame
      local shortcut_hl = "AlphaHeader" .. current_frame
      
      for i, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = {{ hl_name, 0, button_configs[i].icon_len }}
        button.opts.hl_shortcut = shortcut_hl
      end

      -- Single redraw call
      vim.schedule(function()
        if vim.bo.filetype == "alpha" then
          pcall(alpha.redraw)
        end
        is_animating = false
      end)

      current_frame = current_frame % #frames + 1
    end

    -- Start animation only when on alpha buffer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        if timer then
          timer:stop()
        end
        timer = vim.loop.new_timer()
        timer:start(500, 800, vim.schedule_wrap(animate))
      end,
    })

    -- Stop animation when leaving alpha
    vim.api.nvim_create_autocmd("BufLeave", {
      pattern = "*",
      callback = function()
        if timer and vim.bo.filetype == "alpha" then
          timer:stop()
          timer = nil
        end
      end,
    })
  end,
}