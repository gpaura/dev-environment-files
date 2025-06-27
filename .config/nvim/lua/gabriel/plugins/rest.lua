-- ~/.config/nvim/lua/gabriel/plugins/rest.lua
return {
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "http" },
    keys = {
      { "<leader>rr", "<Plug>RestNvim", desc = "Run request under cursor" },
      { "<leader>rp", "<Plug>RestNvimPreview", desc = "Preview request cURL command" },
      { "<leader>rl", "<Plug>RestNvimLast", desc = "Re-run last request" },
    },
    config = function()
      require("rest-nvim").setup({
        result_split_horizontal = false,
        result_split_in_place = false,
        skip_ssl_verification = false,
        highlight = {
          enabled = true,
          timeout = 150,
        },
        jump_to_request = false,
      })
    end,
  },
}
