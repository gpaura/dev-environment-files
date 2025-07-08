-- ~/.config/nvim/init.lua
require("gabriel.core") -- Or however you load your core.lua
require("gabriel.lazy")

-- Function to close Neovim when closing the last tab
vim.api.nvim_create_user_command("SmartTabClose", function()
  if vim.fn.tabpagenr("$") == 1 then
    vim.cmd("quit")
  else
    vim.cmd("tabclose")
  end -- Changed from 'endif' to 'end'
end, {})

-- Create a key mapping for the smart tab close (optional)
-- You can change <leader>tc to any key combination you prefer
vim.keymap.set("n", "<leader>tc", ":SmartTabClose<CR>", { noremap = true, silent = true })

-- Disable csv.vim plugin to prevent conflicts with rainbow_csv
vim.g.loaded_csv = 1

-- Colorizer autocmd
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    local ok, colorizer = pcall(require, "colorizer")
    if ok then
      pcall(colorizer.attach_to_buffer, 0)
    end
  end,
})

-- Simple Magic command
vim.api.nvim_create_user_command("Magic", function()
  if vim.bo.filetype == "csv" then
    if vim.fn.exists(":RainbowAlign") > 0 then
      vim.cmd("RainbowAlign")
      vim.notify("✨ Magic! CSV aligned", vim.log.levels.INFO)
    else
      vim.notify("RainbowAlign not available", vim.log.levels.WARN)
    end
  else
    vim.notify("Magic only works in CSV files!", vim.log.levels.WARN)
  end
end, { desc = "Magic CSV alignment" })

-- Details command for comprehensive CSV file analysis
vim.api.nvim_create_user_command("Details", function()
  local ft = vim.bo.filetype
  local fname = vim.fn.expand("%:t")
  local fpath = vim.fn.expand("%:p")
  local has_csv_content = false
  
  -- Check if this looks like a CSV file
  if ft == "csv" or fname:match("%.csv$") or fname:match("%.dat$") or fname:match("%.tsv$") then
    has_csv_content = true
  else
    -- Check if current buffer has delimiter-separated content
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
    -- But continue anyway for basic file info
  end
  
  -- Get all lines from the buffer
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
      -- Count columns in this row
      local columns = {}
      if delimiter == "\t" then
        for field in line:gmatch("([^\t]*)\t?") do
          table.insert(columns, field)
        end
      else
        -- Handle quoted fields properly
        local in_quotes = false
        local current_field = ""
        local char_delim = delimiter:sub(1,1)
        
        for char in line:gmatch(".") do
          if char == '"' then
            in_quotes = not in_quotes
          elseif char == char_delim and not in_quotes then
            table.insert(columns, current_field)
            current_field = ""
          else
            current_field = current_field .. char
          end
        end
        -- Add the last field
        table.insert(columns, current_field)
      end
      
      local col_count = #columns
      max_columns = math.max(max_columns, col_count)
      min_columns = math.min(min_columns, col_count)
      
      -- Store column info for the first row (potential header)
      if i == 1 then
        column_info = columns
        -- Simple heuristic: if first row has no numbers, it might be a header
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
  
  -- Calculate file size
  local file_size = 0
  if vim.fn.filereadable(fpath) == 1 then
    file_size = vim.fn.getfsize(fpath)
  end
  
  local function format_bytes(bytes)
    if bytes < 1024 then
      return bytes .. " B"
    elseif bytes < 1024 * 1024 then
      return string.format("%.1f KB", bytes / 1024)
    elseif bytes < 1024 * 1024 * 1024 then
      return string.format("%.1f MB", bytes / (1024 * 1024))
    else
      return string.format("%.1f GB", bytes / (1024 * 1024 * 1024))
    end
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
  
  -- Prepare the details report
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
  
  -- Add column headers if detected
  if has_header and #column_info > 0 then
    table.insert(report, "")
    table.insert(report, "📑 Column Headers:")
    for i, header in ipairs(column_info) do
      if i <= 10 then -- Limit to first 10 columns
        table.insert(report, "   " .. i .. ". " .. (header ~= "" and header or "<empty>"))
      elseif i == 11 then
        table.insert(report, "   ... and " .. (#column_info - 10) .. " more columns")
        break
      end
    end
  end
  
  -- Add sample data preview
  if total_rows > (has_header and 1 or 0) then
    table.insert(report, "")
    table.insert(report, "👀 Sample Data:")
    local start_row = has_header and 2 or 1
    local preview_rows = math.min(3, total_rows - start_row + 1)
    
    for i = start_row, start_row + preview_rows - 1 do
      if lines[i] and #lines[i] > 0 then
        local preview = lines[i]
        if #preview > 60 then
          preview = preview:sub(1, 57) .. "..."
        end
        table.insert(report, "   Row " .. i .. ": " .. preview)
      end
    end
    
    if total_rows > start_row + preview_rows - 1 then
      table.insert(report, "   ... and " .. (total_rows - start_row - preview_rows + 1) .. " more rows")
    end
  end
  
  table.insert(report, "")
  table.insert(report, "═══════════════════════════════════════════════════════════════")
  
  -- Display the report in a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, report)
  
  -- Calculate window size
  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(#report + 2, vim.o.lines - 4)
  
  -- Create floating window
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
  
  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_win_set_option(win, "wrap", false)
  vim.api.nvim_win_set_option(win, "cursorline", true)
  
  -- Add syntax highlighting
  vim.api.nvim_buf_set_option(buf, "filetype", "text")
  
  -- Key mappings to close the window
  local close_keys = { "q", "<Esc>", "<CR>" }
  for _, key in ipairs(close_keys) do
    vim.api.nvim_buf_set_keymap(buf, "n", key, "<cmd>close<CR>", 
      { noremap = true, silent = true })
  end
  
  -- Also show a brief summary in the command line
  local summary = string.format("📊 %d rows × %d cols | %s | %s", 
    total_rows, 
    max_columns > 0 and max_columns or 0,
    format_bytes(file_size > 0 and file_size or total_chars),
    format_delimiter(delimiter)
  )
  
  vim.notify(summary, vim.log.levels.INFO)
  
end, { desc = "Show detailed CSV file information" })

-- Simple Details command for quick stats
vim.api.nvim_create_user_command("SimpleDetails", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local fname = vim.fn.expand("%:t")
  local fpath = vim.fn.expand("%:p")
  local total_rows = #lines
  local total_chars = 0
  
  -- Calculate total characters
  for _, line in ipairs(lines) do
    total_chars = total_chars + #line
  end
  
  -- Get file size
  local file_size = vim.fn.filereadable(fpath) == 1 and vim.fn.getfsize(fpath) or 0
  
  -- Detect delimiter and count columns
  local delimiter = ","
  local max_columns = 0
  
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
    
    -- Count columns (add 1 since delimiter count is n-1 for n columns)
    max_columns = max_count + 1
  end
  
  local function format_bytes(bytes)
    if bytes < 1024 then return bytes .. "B"
    elseif bytes < 1024*1024 then return string.format("%.1fKB", bytes/1024)
    else return string.format("%.1fMB", bytes/(1024*1024)) end
  end
  
  local delim_name = delimiter == "\t" and "Tab" or 
                     delimiter == "," and "Comma" or 
                     delimiter == ";" and "Semicolon" or 
                     delimiter == "|" and "Pipe" or delimiter
  
  -- Print details
  print("📊 " .. fname .. " | " .. total_rows .. " rows × " .. max_columns .. " cols | " .. 
        format_bytes(file_size > 0 and file_size or total_chars) .. " | " .. delim_name)
  
end, { desc = "Show simple CSV file stats" })

-- Add this new autocmd to track startup time
vim.g.start_time = vim.loop.hrtime()
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.g.startuptime = (vim.loop.hrtime() - vim.g.start_time) / 1000000
  end,
})


-- CSV File Splitter Commands - Split current file into smaller chunks
-- Helper function to split current CSV file
local function split_current_csv(num_lines, command_name)
  -- Check if current buffer has content
  local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local total_lines = #current_lines
  
  if total_lines == 0 then
    vim.notify("No content in current buffer to split!", vim.log.levels.WARN)
    return
  end
  
  if total_lines <= num_lines then
    vim.notify(string.format("Current file only has %d lines (requested %d lines)", total_lines, num_lines), vim.log.levels.WARN)
    return
  end
  
  -- Get current file info
  local current_file = vim.fn.expand("%:p")
  local current_name = vim.fn.expand("%:t:r") -- filename without extension
  local current_ext = vim.fn.expand("%:e")   -- extension
  
  if current_name == "" then
    current_name = "untitled"
  end
  if current_ext == "" then
    current_ext = "csv"
  end
  
  -- Create temp directory
  local temp_dir = vim.fn.expand("~/.config/nvim/cache/csv_temp")
  if vim.fn.isdirectory(temp_dir) == 0 then
    local result = vim.fn.mkdir(temp_dir, "p")
    if result == 0 then
      vim.notify("Error: Could not create directory " .. temp_dir, vim.log.levels.ERROR)
      return
    end
  end
  
  -- Generate new filename
  local timestamp = os.date("%Y%m%d_%H%M%S")
  local new_filename = string.format("%s_first_%dk_%s.%s", current_name, math.floor(num_lines/1000), timestamp, current_ext)
  local new_filepath = temp_dir .. "/" .. new_filename
  
  -- Extract the first num_lines from current buffer
  vim.notify(string.format("Splitting first %d lines from %s (%d total lines)...", num_lines, current_name, total_lines), vim.log.levels.INFO)
  
  local lines_to_save = {}
  for i = 1, math.min(num_lines, total_lines) do
    table.insert(lines_to_save, current_lines[i])
  end
  
  -- Write directly to file
  local file = io.open(new_filepath, "w")
  if not file then
    vim.notify("Error: Could not create file " .. new_filepath, vim.log.levels.ERROR)
    return
  end
  
  for _, line in ipairs(lines_to_save) do
    file:write(line .. "\n")
  end
  file:close()
  
  -- Open the new file in a new tab
  vim.cmd("tabnew " .. vim.fn.fnameescape(new_filepath))
  
  -- Set filetype explicitly
  vim.bo.filetype = current_ext == "csv" and "csv" or 
                   current_ext == "dat" and "csv" or 
                   current_ext == "tsv" and "csv" or "csv"
  
  -- Success message
  local file_size = vim.fn.getfsize(new_filepath)
  local function format_bytes(bytes)
    if bytes < 1024 then return bytes .. "B"
    elseif bytes < 1024*1024 then return string.format("%.1fKB", bytes/1024)
    else return string.format("%.1fMB", bytes/(1024*1024)) end
  end
  
  vim.notify(string.format("✅ Created %s with %d lines (%s)", 
    new_filename, #lines_to_save, format_bytes(file_size)), vim.log.levels.INFO)
  
  -- Auto-run Details command if available
  vim.defer_fn(function()
    if vim.fn.exists(":Details") > 0 then
      vim.cmd("Details")
    end
  end, 500)
end

-- Create the split commands
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

-- Additional command to split by percentage
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
end, { 
  nargs = 1, 
  desc = "Split current CSV file by percentage (e.g., :CreatePercent 25)" 
})

-- Command to create multiple splits at once
vim.api.nvim_create_user_command("CreateAll", function()
  local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local total_lines = #current_lines
  
  if total_lines == 0 then
    vim.notify("No content in current buffer to split!", vim.log.levels.WARN)
    return
  end
  
  vim.notify(string.format("Creating multiple splits from %d total lines...", total_lines), vim.log.levels.INFO)
  
  local splits = {1000, 10000, 50000, 100000}
  local created = 0
  
  for _, num_lines in ipairs(splits) do
    if total_lines > num_lines then
      split_current_csv(num_lines, "CreateAll")
      created = created + 1
      -- Small delay between operations
      vim.defer_fn(function() end, 100)
    end
  end
  
  if created == 0 then
    vim.notify("File too small to create any splits (needs > 1000 lines)", vim.log.levels.WARN)
  else
    vim.notify(string.format("✅ Created %d split files", created), vim.log.levels.INFO)
  end
end, { desc = "Create all possible splits (1k, 10k, 50k, 100k) from current file" })

-- Bonus: Create a command to clean up temp files
vim.api.nvim_create_user_command("CleanCSVTemp", function()
  local temp_dir = vim.fn.expand("~/.config/nvim/cache/csv_temp")
  if vim.fn.isdirectory(temp_dir) == 1 then
    local files = vim.fn.glob(temp_dir .. "/*.{csv,dat,tsv}", false, true)
    local count = 0
    for _, file in ipairs(files) do
      if vim.fn.delete(file) == 0 then
        count = count + 1
      end
    end
    vim.notify(string.format("🧹 Cleaned up %d temporary files from %s", count, temp_dir), vim.log.levels.INFO)
  else
    vim.notify("No temporary CSV files to clean", vim.log.levels.INFO)
  end
end, { desc = "Clean up temporary CSV split files" })

-- Command to list temp files
vim.api.nvim_create_user_command("ListCSVTemp", function()
  local temp_dir = vim.fn.expand("~/.config/nvim/cache/csv_temp")
  if vim.fn.isdirectory(temp_dir) == 1 then
    local files = vim.fn.glob(temp_dir .. "/*.{csv,dat,tsv}", false, true)
    if #files > 0 then
      vim.notify("📂 Temporary split files in " .. temp_dir .. ":", vim.log.levels.INFO)
      for _, file in ipairs(files) do
        local name = vim.fn.fnamemodify(file, ":t")
        local size = vim.fn.getfsize(file)
        local size_str = size < 1024 and (size .. "B") or 
                        size < 1024*1024 and string.format("%.1fKB", size/1024) or
                        string.format("%.1fMB", size/(1024*1024))
        print("  " .. name .. " (" .. size_str .. ")")
      end
    else
      vim.notify("No temporary split files found in " .. temp_dir, vim.log.levels.INFO)
    end
  else
    vim.notify("Temporary CSV directory doesn't exist: " .. temp_dir, vim.log.levels.INFO)
  end
end, { desc = "List temporary CSV split files" })

-- Command to open temp directory in file explorer
vim.api.nvim_create_user_command("OpenCSVTemp", function()
  local temp_dir = vim.fn.expand("~/.config/nvim/cache/csv_temp")
  if vim.fn.isdirectory(temp_dir) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(temp_dir))
  else
    vim.notify("Temporary CSV directory doesn't exist: " .. temp_dir, vim.log.levels.WARN)
  end
end, { desc = "Open temporary CSV split directory" })

-- Command to quickly analyze current file size and suggest splits
vim.api.nvim_create_user_command("AnalyzeSplits", function()
  local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local total_lines = #current_lines
  local current_name = vim.fn.expand("%:t")
  
  if total_lines == 0 then
    vim.notify("No content in current buffer", vim.log.levels.WARN)
    return
  end
  
  local splits = {
    {1000, "1k"},
    {10000, "10k"}, 
    {50000, "50k"},
    {100000, "100k"}
  }
  
  local report = {
    "📊 SPLIT ANALYSIS FOR: " .. current_name,
    "═══════════════════════════════════════════════════════════════",
    "",
    "📋 Current File:",
    "   Total Lines: " .. total_lines,
    "",
    "✂️  Available Splits:",
  }
  
  local available_splits = 0
  for _, split in ipairs(splits) do
    local lines, label = split[1], split[2]
    if total_lines > lines then
      table.insert(report, string.format("   ✅ :Create%d - First %s lines (%d lines)", lines, label, lines))
      available_splits = available_splits + 1
    else
      table.insert(report, string.format("   ❌ :Create%d - Not enough lines (need >%d)", lines, lines))
    end
  end
  
  table.insert(report, "")
  table.insert(report, "🎯 Quick Commands:")
  if available_splits > 0 then
    table.insert(report, "   :CreateAll - Create all available splits")
    table.insert(report, "   :CreatePercent 25 - Create 25% split (" .. math.floor(total_lines * 0.25) .. " lines)")
  else
    table.insert(report, "   File too small for standard splits")
    table.insert(report, "   Try :CreatePercent 50 for half the file")
  end
  
  table.insert(report, "")
  table.insert(report, "═══════════════════════════════════════════════════════════════")
  
  -- Display in floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, report)
  
  local width = 70
  local height = math.min(#report + 2, vim.o.lines - 4)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
    title = " Split Analysis ",
    title_pos = "center",
  })
  
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_win_set_option(win, "cursorline", true)
  
  -- Close window keymaps
  local close_keys = { "q", "<Esc>", "<CR>" }
  for _, key in ipairs(close_keys) do
    vim.api.nvim_buf_set_keymap(buf, "n", key, "<cmd>close<CR>", 
      { noremap = true, silent = true })
  end
  
end, { desc = "Analyze current file and show available split options" })

-- Add helpful keymaps for CSV splitting
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"csv", "dat", "tsv"},
  callback = function()
    local opts = { buffer = true, silent = true }
    
    -- Quick split commands
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