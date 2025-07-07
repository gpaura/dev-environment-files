return {
  -- Core dependencies
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  
  -- Rainbow delimiters (using the modern plugin instead of the deprecated one)
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')
      
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterBlue',
          'RainbowDelimiterPurple',
          'RainbowDelimiterGreen',
          'RainbowDelimiterOrange',
          'RainbowDelimiterPink',
          'RainbowDelimiterTeal',
        },
      }
      
      -- Define BOLDER and more vibrant colors
      vim.cmd([[
        highlight RainbowDelimiterRed guifg=#D70000 gui=bold ctermfg=160 cterm=bold
        highlight RainbowDelimiterBlue guifg=#0550AE gui=bold ctermfg=25 cterm=bold
        highlight RainbowDelimiterPurple guifg=#8000FF gui=bold ctermfg=93 cterm=bold
        highlight RainbowDelimiterGreen guifg=#007F0E gui=bold ctermfg=28 cterm=bold
        highlight RainbowDelimiterOrange guifg=#FF5D00 gui=bold ctermfg=202 cterm=bold
        highlight RainbowDelimiterPink guifg=#F6019D gui=bold ctermfg=199 cterm=bold
        highlight RainbowDelimiterTeal guifg=#009FAA gui=bold ctermfg=37 cterm=bold
      ]])
    end,
  },
  
  -- Updated Treesitter config that removes the deprecated rainbow plugin
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "query" },
        highlight = {
          enable = true,
        },
        -- Rainbow config removed since we're now using rainbow-delimiters.nvim
      })
    end,
  },

  -- Obsidian plugin
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/vaults/personal",
        },
        {
          name = "work", 
          path = "~/vaults/work",
        },
      },
      -- Disable UI to avoid conflicts with render-markdown
      ui = { 
        enable = false 
      },
    },
  },
  
  -- Vim-dadbod
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion"
    },
  },
  
  -- Git blame
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%m-%d-%Y %H:%M:%S",
      virtual_text_column = 1,
    },
  },
  
  -- Avante plugin
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      provider = "openai",
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o",
        timeout = 30000,
        temperature = 0,
        max_completion_tokens = 8192,
      },
    },
    build = "make",
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
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
          -- Disable LaTeX support to avoid warnings
          latex = { 
            enabled = false 
          },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
