-- ~/.config/nvim/init.lua
require("gabriel.core")
require("gabriel.lazy")

-- Function to close Neovim when closing the last tab
vim.api.nvim_create_user_command("SmartTabClose", function()
  if vim.fn.tabpagenr("$") == 1 then
    vim.cmd("quit")
  else
    vim.cmd("tabclose")
  end
end, {})

-- Create a key mapping for the smart tab close (optional)
vim.keymap.set("n", "<leader>tc", ":SmartTabClose<CR>", { noremap = true, silent = true })

-- CSV settings - DISABLE auto-arrangement, enable Magic command instead
vim.g.csv_autocmd_arrange = 0 -- Disable auto-alignment - use Magic command instead
vim.g.csv_no_conceal = 1 -- Show real separators like commas etc.

-- Colorizer for all files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    local ok, colorizer = pcall(require, "colorizer")
    if ok then
      pcall(colorizer.attach_to_buffer, 0)
    end
  end,
})

-- Improved detection for extensionless CSV files (colorization only)
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    local fname = vim.fn.expand("%:t")

    -- Only process files without extensions
    if fname == "" or fname:match("%..+$") then
      return
    end

    -- Check first 10 lines for CSV patterns
    local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
    local comma_count = 0
    local examined = 0

    for _, line in ipairs(lines) do
      if line and #line > 0 then
        examined = examined + 1
        -- Count commas in the line
        comma_count = comma_count + select(2, line:gsub(",", ""))
      end
    end

    -- If we have a decent number of commas, it's likely a CSV
    if examined > 0 and (comma_count / examined) >= 2 then
      -- Set filetype to CSV
      vim.bo.filetype = "csv"
      vim.b.csv_delimiter = ","

      -- Apply rainbow highlighting ONLY (no alignment)
      vim.defer_fn(function()
        -- Try to find a comma for highlighting
        for i, line in ipairs(lines) do
          local comma_pos = string.find(line, ",")
          if comma_pos then
            -- Save cursor position
            local cursor_pos = vim.fn.getcurpos()
            -- Move to comma position
            vim.fn.cursor(i, comma_pos)
            -- Apply rainbow highlighting ONLY
            pcall(vim.cmd, "RainbowDelim")
            -- Restore cursor position
            vim.fn.setpos(".", cursor_pos)
            break
          end
        end

        -- Mark buffer as unmodified (no formatting was applied)
        vim.cmd("set nomodified")
      end, 100)
    end
  end,
  group = vim.api.nvim_create_augroup("CSVExtensionless", { clear = true }),
})

-- Track startup time
vim.g.start_time = vim.loop.hrtime()
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.g.startuptime = (vim.loop.hrtime() - vim.g.start_time) / 1000000
  end,
})

-- PERFECT MAGIC COMMAND - Uses the same mechanism as vim.g.csv_autocmd_arrange = 1
vim.api.nvim_create_user_command("Magic", function()
  local ft = vim.bo.filetype
  local fname = vim.fn.expand("%:t")
  local has_csv_content = false
  
  -- Check if it's explicitly a CSV file or has CSV-like content
  if ft == "csv" or fname:match("%.csv$") or fname:match("%.dat$") then
    has_csv_content = true
  else
    -- Check if current buffer has comma-separated content
    local lines = vim.api.nvim_buf_get_lines(0, 0, 5, false)
    for _, line in ipairs(lines) do
      if line:find(",") then
        has_csv_content = true
        break
      end
    end
  end
  
  if not has_csv_content then
    vim.notify("Magic works on CSV files or comma-separated data!", vim.log.levels.WARN)
    return
  end
  
  -- Set filetype to csv if not already set
  if ft ~= "csv" then
    vim.bo.filetype = "csv"
    vim.notify("Setting filetype to CSV", vim.log.levels.INFO)
  end
  
  -- Save current state
  local original_arrange = vim.g.csv_autocmd_arrange
  local cursor_pos = vim.fn.getcurpos()
  
  -- Temporarily enable the PERFECT auto-arrangement mechanism
  vim.g.csv_autocmd_arrange = 1
  
  -- Trigger the CSV plugin's built-in arrangement that works perfectly
  -- This is the EXACT same mechanism that gives perfect alignment
  vim.cmd("silent! doautocmd FileType csv")
  
  -- Restore cursor position
  vim.fn.setpos(".", cursor_pos)
  
  -- Restore original setting and mark as unmodified
  vim.defer_fn(function()
    vim.g.csv_autocmd_arrange = original_arrange or 0
    vim.cmd("set nomodified")
    vim.notify("✨ Magic CSV alignment applied using PERFECT built-in mechanism!", vim.log.levels.INFO)
  end, 300)
  
end, { desc = "Apply PERFECT CSV alignment using built-in mechanism" })

-- Unmagic command to remove alignment
vim.api.nvim_create_user_command("Unmagic", function()
  local success = pcall(function()
    vim.cmd("RainbowNoAlign")
  end)
  
  if success then
    vim.notify("🔄 CSV alignment removed!", vim.log.levels.INFO)
  else
    vim.notify("❌ Failed to remove alignment", vim.log.levels.ERROR)
  end
end, { desc = "Remove CSV column alignment" })

-- Test command to verify everything is working
vim.api.nvim_create_user_command("TestMagic", function()
  vim.notify("Testing Magic setup...", vim.log.levels.INFO)
  vim.notify("Current filetype: " .. vim.bo.filetype, vim.log.levels.INFO)
  vim.notify("csv_autocmd_arrange: " .. vim.g.csv_autocmd_arrange, vim.log.levels.INFO)
  vim.notify("RainbowAlign exists: " .. vim.fn.exists(":RainbowAlign"), vim.log.levels.INFO)
  vim.notify("RainbowDelim exists: " .. vim.fn.exists(":RainbowDelim"), vim.log.levels.INFO)
  vim.notify("Magic exists: " .. vim.fn.exists(":Magic"), vim.log.levels.INFO)
end, { desc = "Test Magic command setup" })

-- Details command for CSV file analysis
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