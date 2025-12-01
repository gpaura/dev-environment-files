return {
  -- Main LSP configuration with Mason integration
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 100,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      {
        "folke/neodev.nvim",
        opts = {
          library = {
            enabled = true,
            runtime = true,
            types = true,
            plugins = true,
          },
        },
      },
    },
    config = function()
      -- First set up mason
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- Configure neodev for better Lua development (before lspconfig setup)
      require("neodev").setup({
        library = {
          enabled = true,
          runtime = true,
          types = true,
          plugins = true,
        },
      })

      -- Set up completion capabilities
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

      -- Modern approach for setting diagnostic signs
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        virtual_text = {
          prefix = "●", -- Could be '■', '▎', 'x'
        },
        float = {
          border = "rounded",
        },
        severity_sort = true,
        update_in_insert = false,
      })

      -- Set up mason-lspconfig with handlers inline
      require("mason-lspconfig").setup({
        -- Make sure these server names match what lspconfig uses
        ensure_installed = {
          "pyright",
          "gopls",
          "eslint",
          "angularls",
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          "bashls",
          "sqlls",
          "lua_ls",
          "tailwindcss",
          "omnisharp",
          "svelte",
          "graphql",
          "emmet_ls",
          "prismals",
        },
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Specific server configurations
          ["omnisharp"] = function()
            lspconfig.omnisharp.setup({
              capabilities = capabilities,
              cmd = { "omnisharp" },
              filetypes = { "cs", "csx", "razor" },
              root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln"),
              settings = {
                omnisharp = {
                  useModernNet = true,
                  enableRoslynAnalyzers = true,
                  enableEditorConfigSupport = true,
                  enableImportCompletion = true,
                  organizeImportsOnFormat = true,
                },
              },
            })
          end,

          ["pyright"] = function()
            lspconfig.pyright.setup({
              capabilities = capabilities,
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                  },
                },
              },
            })
          end,

          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              -- Prevent runtime file scanning for wezterm files
              before_init = function(params, config)
                -- Redirect workspace to a temp directory for wezterm files only
                if params.rootUri and params.rootUri:match("wezterm%.lua$") then
                  -- Create a temporary directory structure just for this file
                  local tmp_dir = vim.fn.stdpath("cache") .. "/wezterm_lsp"
                  vim.fn.mkdir(tmp_dir, "p")
                  params.rootUri = "file://" .. tmp_dir

                  -- Copy just this file to the temp dir for analysis
                  local current_file = vim.fn.expand("%:p")
                  local dest_file = tmp_dir .. "/wezterm.lua"
                  vim.fn.system({ "cp", current_file, dest_file })
                end
                return true
              end,
              settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = {
                    -- Only add wezterm for wezterm files, vim is handled by neodev
                    globals = { "vim", "wezterm" },
                  },
                  workspace = {
                    checkThirdParty = false,
                    -- Let neodev handle the library setup for Neovim files
                    library = {},
                    -- Use small limits to prevent scanning large directories
                    maxPreload = 100,
                    preloadFileSize = 10000,
                  },
                  telemetry = { enable = false },
                  completion = {
                    callSnippet = "Replace",
                  },
                },
              },
              flags = {
                debounce_text_changes = 150,
              },
              -- Better root directory detection
              root_dir = function(fname)
                if fname:match("wezterm%.lua$") then
                  return vim.fn.stdpath("cache") .. "/wezterm_lsp"
                end
                return lspconfig.util.find_git_ancestor(fname)
                  or lspconfig.util.root_pattern("init.lua", ".luarc.json", ".git")(fname)
                  or lspconfig.util.path.dirname(fname)
              end,
            })
          end,
        },
      })
    end,
  },

  -- LSP indicator
  {
    "j-hui/fidget.nvim",
    opts = {},
  },

  -- LSP keymaps (separate configuration to avoid circular dependencies)
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Global mappings
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add diagnostics to location list" })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings
          local opts = { buffer = ev.buf, silent = true }

          -- Set keybinds with descriptions for which-key integration
          vim.keymap.set(
            "n",
            "gR",
            "<cmd>Telescope lsp_references<CR>",
            { buffer = ev.buf, desc = "Show LSP references" }
          )
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
          vim.keymap.set(
            "n",
            "gd",
            "<cmd>Telescope lsp_definitions<CR>",
            { buffer = ev.buf, desc = "Show LSP definitions" }
          )
          vim.keymap.set(
            "n",
            "gi",
            "<cmd>Telescope lsp_implementations<CR>",
            { buffer = ev.buf, desc = "Show LSP implementations" }
          )
          vim.keymap.set(
            "n",
            "gt",
            "<cmd>Telescope lsp_type_definitions<CR>",
            { buffer = ev.buf, desc = "Show LSP type definitions" }
          )
          vim.keymap.set(
            { "n", "v" },
            "<leader>ca",
            vim.lsp.buf.code_action,
            { buffer = ev.buf, desc = "See available code actions" }
          )
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Smart rename" })
          vim.keymap.set(
            "n",
            "<leader>D",
            "<cmd>Telescope diagnostics bufnr=0<CR>",
            { buffer = ev.buf, desc = "Show buffer diagnostics" }
          )
          vim.keymap.set(
            "n",
            "K",
            vim.lsp.buf.hover,
            { buffer = ev.buf, desc = "Show documentation for what is under cursor" }
          )
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
          vim.keymap.set(
            "n",
            "<leader>wa",
            vim.lsp.buf.add_workspace_folder,
            { buffer = ev.buf, desc = "Add workspace folder" }
          )
          vim.keymap.set(
            "n",
            "<leader>wr",
            vim.lsp.buf.remove_workspace_folder,
            { buffer = ev.buf, desc = "Remove workspace folder" }
          )
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { buffer = ev.buf, desc = "List workspace folders" })
          vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", { buffer = ev.buf, desc = "Restart LSP" })
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, { buffer = ev.buf, desc = "Format code" })
        end,
      })
    end,
  },

  -- Python debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "Open REPL",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run last",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      require("dap-python").setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}