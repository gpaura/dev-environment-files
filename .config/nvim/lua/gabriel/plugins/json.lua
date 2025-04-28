-- ~/.config/nvim/lua/gabriel/plugins/json.lua
return {
  {
    "b0o/SchemaStore.nvim", -- JSON Schema support
  },
  {
    "gennaro-tedesco/nvim-jqx", -- jq integration for JSON files
    ft = { "json", "yaml" },
  },
}
