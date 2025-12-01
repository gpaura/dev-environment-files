return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  config = function()
    -- Define highlight groups before setup
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4252", bold = true, bg = "none" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#88c0d0", bold = true, bg = "none" })

    require("ibl").setup({
      indent = {
        char = "┊",
        highlight = "IblIndent",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        highlight = "IblScope",
      },
    })
  end,
}