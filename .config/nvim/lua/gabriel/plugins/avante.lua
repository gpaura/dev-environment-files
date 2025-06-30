-- ~/.config/nvim/lua/gabriel/plugins/avante.lua
-- Enhanced Avante AI configuration with updated providers format

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  config = function()
    local colors = {}

    -- Get current theme from WezTerm config
    local function get_theme()
      local file = io.open(os.getenv("HOME") .. "/.config/wezterm/theme", "r")
      if file then
        local theme = file:read("*all")
        file:close()
        return theme:gsub("%s+", "") -- Trim whitespace
      else
        return "dark" -- Default to dark theme
      end
    end

    -- Dark theme colors (inspired by your Tokyo Night theme)
    colors.dark = {
      primary = "#7AA2F7", -- Tokyo Night blue
      secondary = "#BB9AF7", -- Tokyo Night purple
      accent = "#FF79C6", -- Dracula pink
      bg = "#1A1B26", -- Tokyo Night background
      fg = "#F8F8F2", -- Bright text
      border = "#414868", -- Tokyo Night dark blue-gray
      highlight_bg = "#24283B", -- Slightly lighter background for highlighting
    }

    -- Light theme colors (inspired by your WezTerm light theme)
    colors.light = {
      primary = "#9D50FF", -- Purple
      secondary = "#FF3388", -- Pink
      accent = "#FF2D76", -- Bright pink
      bg = "#FAFAFA", -- Clean off-white background
      fg = "#2D2A2E", -- Darker gray text
      border = "#E0E0E0", -- Light gray border
      highlight_bg = "#F0F0F0", -- Slightly darker background for highlighting
    }

    -- Get current theme
    local current_theme = get_theme()
    local theme_colors = colors[current_theme]

    require("avante").setup({
      -- Updated provider configuration using the new format
      provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-3-5-sonnet-20241022", -- Updated to latest Claude model
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
      },
      
      system_prompt = "You are a helpful coding assistant integrated with Neovim. Please respond in English.", -- Custom system prompt
      
      -- UI Customization
      ui = {
        -- Window appearance
        window = {
          width = 0.8, -- 80% of editor width
          height = 0.8, -- 80% of editor height
          border = "rounded", -- Rounded borders
          winblend = 0, -- No transparency
        },

        -- Custom theme based on current terminal theme
        highlights = {
          border = theme_colors.border,
          background = theme_colors.bg,
          foreground = theme_colors.fg,

          -- Message backgrounds
          user_message_bg = theme_colors.bg,
          assistant_message_bg = theme_colors.highlight_bg,

          -- Message text colors
          user_message_fg = theme_colors.fg,
          assistant_message_fg = theme_colors.fg,

          -- Accent elements
          selection_bg = theme_colors.accent,
          accent = theme_colors.accent,
          cursor = theme_colors.primary,

          -- Input field
          input_bg = theme_colors.bg,
          input_fg = theme_colors.fg,

          -- Headers and controls
          header_bg = theme_colors.bg,
          header_fg = theme_colors.primary,
          button_bg = theme_colors.primary,
          button_fg = theme_colors.bg,
          button_bg_hover = theme_colors.secondary,
        },

        -- Icons - Using Anthropic-themed icon for assistant
        icons = {
          user = "󰀄 ", -- User icon
          assistant = "󱙺 ", -- Updated AI assistant icon for Claude
          thinking = "󰔟 ", -- Thinking animation
          error = " ", -- Error icon
          success = "󰄬 ", -- Success icon
        },
      },

      -- Keymappings for Avante
      keymaps = {
        -- Toggle Avante window
        toggle = "<leader>aa",
        -- Submit prompt
        submit = "<C-Enter>",
        -- Close window
        close = "q",
        -- Copy code from response
        copy_code = "yc",
        -- Clear conversation
        clear = "cc",
      },

      -- File type specific prompts - Adapted for Claude
      filetype_prompts = {
        lua = "You are an expert Lua programmer specializing in Neovim plugins.",
        python = "You are a Python expert focusing on clean and efficient code.",
        javascript = "You are a JavaScript expert with deep knowledge of modern frameworks.",
        typescript = "You are a TypeScript expert with strong typing practices.",
        go = "You are a Go expert who follows idiomatic practices.",
        rust = "You are a Rust expert focused on safety and performance.",
        markdown = "You are an expert at writing clear and concise documentation.",
        sql = "You are an expert SQL DBA expert focusing on clean and efficient queries",
        -- Add more as needed
      },

      -- Features
      features = {
        streaming = true, -- Enable streaming responses
        code_actions = true, -- Enable code actions
        context_awareness = true, -- Enable context awareness
        file_io = true, -- Enable file IO
      },

      -- Experimental features
      experimental = {
        live_suggestions = false,
      },
    })

    -- Set up keymaps
    vim.api.nvim_set_keymap(
      "n",
      "<leader>av",
      ":Avante<CR>",
      { noremap = true, silent = true, desc = "Toggle Avante AI" }
    )
    vim.api.nvim_set_keymap(
      "v",
      "<leader>av",
      ":Avante<CR>",
      { noremap = true, silent = true, desc = "Ask Avante about selection" }
    )

    -- Theme sync - refresh Avante when theme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Reload Avante with new theme colors
        vim.defer_fn(function()
          require("avante").reload()
        end, 100)
      end,
    })
  end,

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}