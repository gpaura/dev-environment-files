return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    -- Define the frames for the animation
    local frames = {
      -- Frame 1: NEO
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
      -- Frame 2: VIM
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
      -- Frame 3: NEOVIM
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
    -- Define the highlight groups
    vim.cmd([[ hi AlphaHeader1 guifg=#61afef gui=bold ]]) -- Blue for NEO
    vim.cmd([[ hi AlphaHeader2 guifg=#ff69b4 gui=bold ]]) -- Pink for VIM
    vim.cmd([[ hi AlphaHeader3 guifg=#b267e6 gui=bold ]]) -- Purple for NEOVIM

    -- Create highlight groups for button icons
    vim.cmd([[ hi AlphaButtonIcon1 guifg=#61afef ]]) -- Blue for icons
    vim.cmd([[ hi AlphaButtonIcon2 guifg=#ff69b4 ]]) -- Pink for icons
    vim.cmd([[ hi AlphaButtonIcon3 guifg=#b267e6 ]]) -- Purple for icons

    -- Set the header
    dashboard.section.header.val = frames[1]
    -- Important: Set the header highlight group based on current frame
    dashboard.section.header.opts.hl = "AlphaHeader1"

    -- Define button creator function with icon highlighting
    local function create_button(sc, txt, keybind)
      local button = dashboard.button(sc, txt, keybind)
      -- Set default highlight for the icon part
      button.opts = {
        position = "center",
        shortcut = sc,
        cursor = 5,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "AlphaHeader1",
        hl = {
          { "AlphaButtonIcon1", 0, 1 }, -- Default to first frame color
        },
      }
      return button
    end

    -- Set menu with custom button function
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Add a message quote to the footer
    dashboard.section.footer.val = "good luck."
    dashboard.section.footer.opts.hl = "AlphaHeader1"
    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

    -- Animation logic
    local current_frame = 1
    local function animate_dashboard()
      -- Update the dashboard header and its highlight group
      pcall(function()
        if dashboard and dashboard.section and dashboard.section.header then
          dashboard.section.header.val = frames[current_frame]
          dashboard.section.header.opts.hl = "AlphaHeader" .. current_frame
          dashboard.section.footer.opts.hl = "AlphaHeader" .. current_frame

          -- Update button icon highlights
          for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = {
              { "AlphaButtonIcon" .. current_frame, 0, 1 },
            }
            button.opts.hl_shortcut = "AlphaHeader" .. current_frame
          end

          pcall(vim.cmd, "redraw")
          pcall(require("alpha").redraw)
        end
      end)

      -- Advance frame
      current_frame = current_frame + 1
      if current_frame > #frames then
        current_frame = 1
      end

      -- Schedule next frame
      vim.defer_fn(animate_dashboard, 800)
    end

    -- Start the animation after a slight delay to let dashboard load
    vim.defer_fn(animate_dashboard, 500)
  end,
}
