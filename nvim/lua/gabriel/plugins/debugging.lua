-- ~/.config/nvim/lua/gabriel/plugins/debugging.lua
-- Debug Adapter Protocol (DAP) configuration

return {
  -- Core DAP plugin
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for DAP
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      -- Virtual text showing variable values
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dt", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup()

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup()

      -- Automatically open/close DAP UI
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

  -- Python DAP
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    build = false, -- Don't build this plugin
    ft = "python",
    config = function()
      -- Try to find debugpy in common locations
      local debugpy_path = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
      if vim.fn.filereadable(debugpy_path) == 0 then
        -- Fallback to system python
        debugpy_path = vim.fn.exepath("python3") or vim.fn.exepath("python")
      end

      require("dap-python").setup(debugpy_path)

      -- Keybindings for Python testing
      vim.keymap.set("n", "<leader>dtm", function() require("dap-python").test_method() end, { desc = "Debug Python Test Method" })
      vim.keymap.set("n", "<leader>dtc", function() require("dap-python").test_class() end, { desc = "Debug Python Test Class" })
    end,
  },
}
