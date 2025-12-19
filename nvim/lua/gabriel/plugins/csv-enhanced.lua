-- Enhanced CSV handling with performance optimizations
local M = {}

local function trim(s)
  return s and s:match("^%s*(.-)%s*$") or s
end

-- Detect separator function
local function detect_separator(sample_lines)
  local separators = {
    {char = ",", name = "comma"},
    {char = ";", name = "semicolon"},
    {char = "|", name = "pipe"},
    {char = "\t", name = "tab"},
    {char = " ", name = "space"}
  }
  
  local max_count = 0
  local detected_sep = nil
  
  for _, sep in ipairs(separators) do
    local count = 0
    local consistent = true
    local counts_per_line = {}
    
    for i = 1, math.min(5, #sample_lines) do
      local line = sample_lines[i]
      if line and #line > 0 then
        local _, line_count = line:gsub(vim.pesc(sep.char), "")
        table.insert(counts_per_line, line_count)
        count = count + line_count
      end
    end
    
    if #counts_per_line > 1 then
      local first_count = counts_per_line[1]
      for i = 2, #counts_per_line do
        if math.abs(counts_per_line[i] - first_count) > 1 then
          consistent = false
          break
        end
      end
    end
    
    if consistent and count > max_count then
      max_count = count
      detected_sep = sep
    end
  end
  
  return detected_sep
end

-- Align content function
local function align_content(lines, separator)
  local rows = {}
  local max_cols = 0
  
  for _, line in ipairs(lines) do
    local cols = {}
    if separator.char == " " then
      for col in line:gmatch("%S+") do
        table.insert(cols, col)
      end
    else
      local pattern = separator.char
      if separator.char == "|" then
        pattern = "%|"
      end
      
      local remaining = line
      while true do
        local pos = remaining:find(pattern)
        if pos then
          table.insert(cols, remaining:sub(1, pos - 1))
          remaining = remaining:sub(pos + 1)
        else
          table.insert(cols, remaining)
          break
        end
      end
    end
    
    table.insert(rows, cols)
    max_cols = math.max(max_cols, #cols)
  end
  
  local col_widths = {}
  for i = 1, max_cols do
    col_widths[i] = 0
  end
  
  for _, row in ipairs(rows) do
    for i, col in ipairs(row) do
      col_widths[i] = math.max(col_widths[i], vim.fn.strdisplaywidth(col))
    end
  end
  
  local aligned_lines = {}
  for _, row in ipairs(rows) do
    local parts = {}
    for i = 1, #row do
      local col = row[i]
      local width = col_widths[i]
      local padding = width - vim.fn.strdisplaywidth(col)
      
      if i < #row then
        table.insert(parts, col .. string.rep(" ", padding))
      else
        table.insert(parts, col)
      end
    end
    
    local sep_with_space = separator.char
    if separator.char ~= " " then
      sep_with_space = " " .. separator.char .. " "
    else
      sep_with_space = "  "
    end
    
    table.insert(aligned_lines, table.concat(parts, sep_with_space))
  end
  
  return aligned_lines
end

-- Enhanced Magic command
vim.api.nvim_create_user_command("Magic", function()
  local line_count = vim.fn.line("$")
  if line_count > 10000 then
    local confirm = vim.fn.confirm(
      string.format("Large file detected (%d lines). Magic alignment may cause slow scrolling. Continue?", line_count),
      "&Yes\n&No", 2)
    if confirm ~= 1 then
      return
    end
  end
  
  if vim.bo.filetype == "csv" then
    local lines = vim.api.nvim_buf_get_lines(0, 0, math.min(5, vim.fn.line("$")), false)
    local has_comma = false
    for _, line in ipairs(lines) do
      if line:find(",") then
        has_comma = true
        break
      end
    end
    
    if has_comma and vim.fn.exists(":RainbowAlign") > 0 then
      vim.cmd("RainbowAlign")
      vim.bo.modified = false
      vim.notify("✨ Magic! CSV aligned with RainbowAlign", vim.log.levels.INFO)
      return
    end
  end
  
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if #lines == 0 then
    vim.notify("No content to align!", vim.log.levels.WARN)
    return
  end
  
  local sep = detect_separator(lines)
  if not sep then
    vim.notify("Could not detect a valid separator (tried: , ; | tab space)", vim.log.levels.WARN)
    return
  end
  
  local aligned = align_content(lines, sep)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, aligned)
  vim.bo.modified = false
  
  vim.notify(string.format("✨ Magic! Aligned using '%s' separator", sep.name), vim.log.levels.INFO)
end, { desc = "Align CSV/table data with auto-detected separator" })

-- UnMagic command
vim.api.nvim_create_user_command("UnMagic", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if #lines == 0 then
    vim.notify("No content to unalign!", vim.log.levels.WARN)
    return
  end
  
  local unaligned_lines = {}
  for _, line in ipairs(lines) do
    local unaligned = line:gsub("  +", " ")
    unaligned = unaligned:gsub(" *| *", "|")
    unaligned = unaligned:gsub(" *, *", ",")
    unaligned = unaligned:gsub(" *; *", ";")
    unaligned = unaligned:gsub(" *\t *", "\t")
    table.insert(unaligned_lines, unaligned)
  end
  
  vim.api.nvim_buf_set_lines(0, 0, -1, false, unaligned_lines)
  vim.notify("✨ Removed alignment!", vim.log.levels.INFO)
end, { desc = "Remove alignment from CSV/table data" })

-- MagicToggle command
vim.api.nvim_create_user_command("MagicToggle", function()
  local first_line = vim.fn.getline(1)
  if first_line:match(" , ") or first_line:match(" | ") or first_line:match(" ; ") or first_line:match("  ") then
    vim.cmd("UnMagic")
  else
    vim.cmd("Magic")
  end
end, { desc = "Toggle between aligned and unaligned" })

-- Quick quit command
vim.api.nvim_create_user_command("Q", function()
  if vim.bo.modified then
    vim.bo.modified = false
  end
  vim.cmd("quit")
end, { desc = "Quit without saving alignment changes" })

-- Keymaps
vim.keymap.set("n", "<leader>ma", ":Magic<CR>", { desc = "Magic align CSV/table" })
vim.keymap.set("n", "<leader>mu", ":UnMagic<CR>", { desc = "Remove Magic alignment" })
vim.keymap.set("n", "<leader>mt", ":MagicToggle<CR>", { desc = "Toggle Magic alignment" })
vim.keymap.set("n", "<leader>Q", ":Q<CR>", { desc = "Quit ignoring alignment changes" })

-- Performance optimizations for CSV files
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = {"*.csv", "*.tsv", "*.dat"},
  callback = function()
    local line_count = vim.fn.line("$")
    if line_count > 10000 then
      vim.wo.cursorline = false
      vim.wo.cursorcolumn = false
      vim.wo.relativenumber = false
      vim.wo.foldmethod = "manual"
      vim.bo.synmaxcol = 200
      vim.notify(string.format("Large CSV detected (%d lines). Disabled some features for performance.", line_count), vim.log.levels.INFO)
    end
  end,
})

-- Auto-disable alignment before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.csv", "*.tsv", "*.dat"},
  callback = function()
    local first_line = vim.fn.getline(1)
    if first_line:match(" , ") or first_line:match(" | ") or first_line:match(" ; ") then
      vim.cmd("silent! UnMagic")
      vim.notify("Auto-removed alignment before saving", vim.log.levels.INFO)
    end
  end,
})

return M