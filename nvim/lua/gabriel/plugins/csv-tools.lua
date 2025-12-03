-- CSV analysis and splitting tools
local M = {}

local function trim(s)
  return s and s:match("^%s*(.-)%s*$") or s
end

local function format_bytes(bytes)
  if bytes < 1024 then
    return bytes .. "B"
  elseif bytes < 1024 * 1024 then
    return string.format("%.1fKB", bytes / 1024)
  else
    return string.format("%.1fMB", bytes / (1024 * 1024))
  end
end

-- CSV file splitter function
local function split_current_csv(num_lines, command_name)
  local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local total_lines = #current_lines

  if total_lines == 0 then
    vim.notify("No content in current buffer to split!", vim.log.levels.WARN)
    return
  end

  if total_lines <= num_lines then
    vim.notify(string.format("Current file only has %d lines (requested %d lines)", total_lines, num_lines),
      vim.log.levels.WARN)
    return
  end

  local current_file = vim.fn.expand("%:p")
  local current_name = vim.fn.expand("%:t:r")
  local current_ext = vim.fn.expand("%:e")

  if current_name == "" then current_name = "untitled" end
  if current_ext == "" then current_ext = "csv" end

  local temp_dir = vim.fn.expand("~/.config/nvim/cache/csv_temp")
  if vim.fn.isdirectory(temp_dir) == 0 then
    local result = vim.fn.mkdir(temp_dir, "p")
    if result == 0 then
      vim.notify("Error: Could not create directory " .. temp_dir, vim.log.levels.ERROR)
      return
    end
  end

  local timestamp = os.date("%Y%m%d_%H%M%S")
  local new_filename = string.format("%s_first_%dk_%s.%s", current_name, math.floor(num_lines / 1000), timestamp,
    current_ext)
  local new_filepath = temp_dir .. "/" .. new_filename

  vim.notify(string.format("Splitting first %d lines from %s (%d total lines)...", num_lines, current_name, total_lines),
    vim.log.levels.INFO)

  local lines_to_save = {}
  for i = 1, math.min(num_lines, total_lines) do
    table.insert(lines_to_save, current_lines[i])
  end

  local file = io.open(new_filepath, "w")
  if not file then
    vim.notify("Error: Could not create file " .. new_filepath, vim.log.levels.ERROR)
    return
  end

  for _, line in ipairs(lines_to_save) do
    file:write(line .. "\n")
  end
  file:close()

  vim.cmd("tabnew " .. vim.fn.fnameescape(new_filepath))
  vim.bo.filetype = current_ext == "csv" and "csv" or current_ext == "dat" and "csv" or current_ext == "tsv" and "csv" or
      "csv"

  local file_size = vim.fn.getfsize(new_filepath)
  vim.notify(string.format("✅ Created %s with %d lines (%s)", new_filename, #lines_to_save, format_bytes(file_size)),
    vim.log.levels.INFO)

  vim.defer_fn(function()
    if vim.fn.exists(":Details") > 0 then
      vim.cmd("Details")
    end
  end, 500)
end

-- Create split commands
vim.api.nvim_create_user_command("Create1000", function()
  split_current_csv(1000, "Create1000")
end, { desc = "Split current CSV file - save first 1,000 lines to temp file" })

vim.api.nvim_create_user_command("Create10000", function()
  split_current_csv(10000, "Create10000")
end, { desc = "Split current CSV file - save first 10,000 lines to temp file" })

vim.api.nvim_create_user_command("Create50000", function()
  split_current_csv(50000, "Create50000")
end, { desc = "Split current CSV file - save first 50,000 lines to temp file" })

vim.api.nvim_create_user_command("Create100000", function()
  split_current_csv(100000, "Create100000")
end, { desc = "Split current CSV file - save first 100,000 lines to temp file" })

-- CreatePercent command
vim.api.nvim_create_user_command("CreatePercent", function(opts)
  local percentage = tonumber(opts.args)
  if not percentage or percentage <= 0 or percentage > 100 then
    vim.notify("Usage: :CreatePercent <1-100> (e.g., :CreatePercent 25 for 25%)", vim.log.levels.ERROR)
    return
  end

  local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local total_lines = #current_lines
  local target_lines = math.floor(total_lines * percentage / 100)

  if target_lines < 1 then
    vim.notify("Calculated lines too small (less than 1 line)", vim.log.levels.WARN)
    return
  end

  split_current_csv(target_lines, "CreatePercent")
end, { nargs = 1, desc = "Split current CSV file by percentage (e.g., :CreatePercent 25)" })

-- CreateAll command
vim.api.nvim_create_user_command("CreateAll", function()
  local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local total_lines = #current_lines

  if total_lines == 0 then
    vim.notify("No content in current buffer to split!", vim.log.levels.WARN)
    return
  end

  vim.notify(string.format("Creating multiple splits from %d total lines...", total_lines), vim.log.levels.INFO)

  local splits = { 1000, 10000, 50000, 100000 }
  local created = 0

  for _, num_lines in ipairs(splits) do
    if total_lines > num_lines then
      split_current_csv(num_lines, "CreateAll")
      created = created + 1
      vim.defer_fn(function() end, 100)
    end
  end

  if created == 0 then
    vim.notify("File too small to create any splits (needs > 1000 lines)", vim.log.levels.WARN)
  else
    vim.notify(string.format("✅ Created %d split files", created), vim.log.levels.INFO)
  end
end, { desc = "Create all possible splits (1k, 10k, 50k, 100k) from current file" })

-- Details command
vim.api.nvim_create_user_command("Details", function()
  local ft = vim.bo.filetype
  local fname = vim.fn.expand("%:t")
  local fpath = vim.fn.expand("%:p")
  local has_csv_content = false

  if ft == "csv" or fname:match("%.csv$") or fname:match("%.dat$") or fname:match("%.tsv$") then
    has_csv_content = true
  else
    local lines = vim.api.nvim_buf_get_lines(0, 0, 5, false)
    for _, line in ipairs(lines) do
      if line:find("[,;|\t]") then
        has_csv_content = true
        break
      end
    end
  end

  if not has_csv_content then
    vim.notify("Details works best on CSV/delimited files!", vim.log.levels.WARN)
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local total_rows = #lines
  local total_chars = 0
  local empty_rows = 0
  local max_columns = 0
  local min_columns = math.huge
  local delimiter = ","
  local has_header = false
  local column_info = {}

  -- Detect delimiter
  if #lines > 0 then
    local first_line = lines[1] or ""
    local delimiters = { ",", ";", "\t", "|" }
    local max_count = 0

    for _, delim in ipairs(delimiters) do
      local count = select(2, first_line:gsub(delim, ""))
      if count > max_count then
        max_count = count
        delimiter = delim
      end
    end
  end

  -- Analyze each row
  for i, line in ipairs(lines) do
    total_chars = total_chars + #line

    if #line == 0 then
      empty_rows = empty_rows + 1
    else
      local columns = {}
      if delimiter == "\t" then
        for field in line:gmatch("([^\t]*)\t?") do
          table.insert(columns, trim(field))
        end
      else
        local in_quotes = false
        local current_field = ""
        local char_delim = delimiter:sub(1, 1)

        for char in line:gmatch(".") do
          if char == '"' then
            in_quotes = not in_quotes
          elseif char == char_delim and not in_quotes then
            table.insert(columns, trim(current_field))
            current_field = ""
          else
            current_field = current_field .. char
          end
        end
        table.insert(columns, trim(current_field))
      end

      local col_count = #columns
      max_columns = math.max(max_columns, col_count)
      min_columns = math.min(min_columns, col_count)

      if i == 1 then
        column_info = columns
        local has_numbers = false
        for _, field in ipairs(columns) do
          if field:match("^%d+%.?%d*$") then
            has_numbers = true
            break
          end
        end
        has_header = not has_numbers and col_count > 1
      end
    end
  end

  local file_size = 0
  if vim.fn.filereadable(fpath) == 1 then
    file_size = vim.fn.getfsize(fpath)
  end

  local function format_delimiter(delim)
    if delim == "\t" then
      return "Tab"
    elseif delim == "," then
      return "Comma"
    elseif delim == ";" then
      return "Semicolon"
    elseif delim == "|" then
      return "Pipe"
    else
      return "'" .. delim .. "'"
    end
  end

  local report = {
    "📊 CSV FILE DETAILS",
    "═══════════════════════════════════════════════════════════════",
    "",
    "📁 File Information:",
    "   Name: " .. fname,
    "   Path: " .. (fpath ~= "" and fpath or "Unnamed buffer"),
    "   Size: " .. (file_size > 0 and format_bytes(file_size) or "Unknown"),
    "   Type: " .. ft,
    "",
    "📋 Data Structure:",
    "   Total Rows: " .. total_rows,
    "   Data Rows: " .. (has_header and (total_rows - 1) or total_rows),
    "   Empty Rows: " .. empty_rows,
    "   Has Header: " .. (has_header and "Yes" or "No"),
    "",
    "📏 Column Information:",
    "   Delimiter: " .. format_delimiter(delimiter),
    "   Max Columns: " .. (max_columns > 0 and max_columns or "N/A"),
    "   Min Columns: " .. (min_columns < math.huge and min_columns or "N/A"),
    "   Consistent: " .. (max_columns == min_columns and "Yes" or "No"),
    "",
    "📊 Content Statistics:",
    "   Total Characters: " .. total_chars,
    "   Avg Line Length: " .. (total_rows > 0 and math.floor(total_chars / total_rows) or 0),
    "   Buffer Modified: " .. (vim.bo.modified and "Yes" or "No"),
  }

  if has_header and #column_info > 0 then
    table.insert(report, "")
    table.insert(report, "📑 Column Headers:")
    for i, header in ipairs(column_info) do
      if i <= 10 then
        table.insert(report, "   " .. i .. ". " .. (header ~= "" and header or "<empty>"))
      elseif i == 11 then
        table.insert(report, "   ... and " .. (#column_info - 10) .. " more columns")
        break
      end
    end
  end

  table.insert(report, "")
  table.insert(report, "═══════════════════════════════════════════════════════════════")

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, report)

  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(#report + 2, vim.o.lines - 4)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
    title = " CSV Details ",
    title_pos = "center",
  })

  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_win_set_option(win, "wrap", false)
  vim.api.nvim_win_set_option(win, "cursorline", true)
  vim.api.nvim_buf_set_option(buf, "filetype", "text")

  local close_keys = { "q", "<Esc>", "<CR>" }
  for _, key in ipairs(close_keys) do
    vim.api.nvim_buf_set_keymap(buf, "n", key, "<cmd>close<CR>", { noremap = true, silent = true })
  end

  local summary = string.format("📊 %d rows × %d cols | %s | %s",
    total_rows,
    max_columns > 0 and max_columns or 0,
    format_bytes(file_size > 0 and file_size or total_chars),
    format_delimiter(delimiter)
  )

  vim.notify(summary, vim.log.levels.INFO)
end, { desc = "Show detailed CSV file information" })

-- CSV-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "dat", "tsv" },
  callback = function()
    local opts = { buffer = true, silent = true }
    vim.keymap.set("n", "<leader>cs", ":AnalyzeSplits<CR>",
      vim.tbl_extend("force", opts, { desc = "Analyze split options" }))
    vim.keymap.set("n", "<leader>c1", ":Create1000<CR>",
      vim.tbl_extend("force", opts, { desc = "Split first 1k lines" }))
    vim.keymap.set("n", "<leader>c2", ":Create10000<CR>",
      vim.tbl_extend("force", opts, { desc = "Split first 10k lines" }))
    vim.keymap.set("n", "<leader>cA", ":CreateAll<CR>",
      vim.tbl_extend("force", opts, { desc = "Create all splits" }))
  end,
})

return M
