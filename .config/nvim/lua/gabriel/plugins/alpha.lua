return {
  "goolord/alpha-nvim",
  event = "vimenter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    -- define the frames for the animation
    local frames = {
      -- frame 1: neo
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
      -- frame 2: vim
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
      -- frame 3: neovim
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
    -- define the highlight groups
    vim.cmd([[ hi alphaheader1 guifg=#61afef gui=bold ]]) -- blue for neo
    vim.cmd([[ hi alphaheader2 guifg=#ff69b4 gui=bold ]]) -- pink for vim
    vim.cmd([[ hi alphaheader3 guifg=#b267e6 gui=bold ]]) -- purple for neovim

    -- create highlight groups for button icons
    vim.cmd([[ hi alphabuttonicon1 guifg=#61afef ]]) -- blue for icons
    vim.cmd([[ hi alphabuttonicon2 guifg=#ff69b4 ]]) -- pink for icons
    vim.cmd([[ hi alphabuttonicon3 guifg=#b267e6 ]]) -- purple for icons

    -- set the header
    dashboard.section.header.val = frames[1]
    -- important: set the header highlight group based on current frame
    dashboard.section.header.opts.hl = "alphaheader1"

    -- define button creator function with icon highlighting
    local function create_button(sc, txt, keybind)
      local button = dashboard.button(sc, txt, keybind)
      -- set default highlight for the icon part
      button.opts = {
        position = "center",
        shortcut = sc,
        cursor = 5,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "alphaheader1",
        hl = {
          { "alphabuttonicon1", 0, 1 }, -- default to first frame color
        },
      }
      return button
    end

    -- set menu with custom button function
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > new file", "<cmd>ene<cr>"),
      dashboard.button("spc ee", "  > toggle file explorer", "<cmd>nvimtreetoggle<cr>"),
      dashboard.button("spc ff", "󰱼  > find file", "<cmd>telescope find_files<cr>"),
      dashboard.button("spc fs", "  > find word", "<cmd>telescope live_grep<cr>"),
      dashboard.button("spc wr", "󰁯  > restore session for current directory", "<cmd>sessionrestore<cr>"),
      dashboard.button("q", "  > quit nvim", "<cmd>qa<cr>"),
    }

    -- add a message quote to the footer
    local function get_plugin_stats()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      return string.format("⚡ Neovim loaded %d/%d plugins in %.2f ms", stats.loaded, stats.count, ms)
    end

    dashboard.section.footer.val = get_plugin_stats
    dashboard.section.footer.opts.hl = "alphaheader1"

    -- Define a function that returns stats as a string

    -- send config to alpha
    alpha.setup(dashboard.opts)

    -- disable folding on alpha buffer
    vim.cmd([[autocmd filetype alpha setlocal nofoldenable]])

    -- animation logic
    local current_frame = 1
    local function animate_dashboard()
      -- update the dashboard header and its highlight group
      pcall(function()
        if dashboard and dashboard.section and dashboard.section.header then
          dashboard.section.header.val = frames[current_frame]
          dashboard.section.header.opts.hl = "alphaheader" .. current_frame
          dashboard.section.footer.opts.hl = "alphaheader" .. current_frame

          -- update button icon highlights
          for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = {
              { "alphabuttonicon" .. current_frame, 0, 1 },
            }
            button.opts.hl_shortcut = "alphaheader" .. current_frame
          end

          pcall(vim.cmd, "redraw")
          pcall(require("alpha").redraw)
        end
      end)

      -- advance frame
      current_frame = current_frame + 1
      if current_frame > #frames then
        current_frame = 1
      end

      -- schedule next frame
      vim.defer_fn(animate_dashboard, 800)
    end

    -- start the animation after a slight delay to let dashboard load
    vim.defer_fn(animate_dashboard, 500)
  end,
}
