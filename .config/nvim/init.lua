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

-- Helper function to generate sample CSV data
local function generate_csv_data(num_rows)
  local data = {}
  
  -- Header row
  table.insert(data, "id,name,email,department,salary,hire_date,active,score")
  
  -- Sample departments and names for variety
  local departments = {"Engineering", "Marketing", "Sales", "HR", "Finance", "Operations", "Legal", "Support"}
  local first_names = {"John", "Jane", "Mike", "Sarah", "David", "Lisa", "Chris", "Emma", "Alex", "Maria"}
  local last_names = {"Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez"}
  local domains = {"company.com", "business.org", "corp.net", "enterprise.com", "tech.io"}
  
  -- Generate data rows
  for i = 1, num_rows do
    local first_name = first_names[((i - 1) % #first_names) + 1]
    local last_name = last_names[((i - 1) % #last_names) + 1]
    local department = departments[((i - 1) % #departments) + 1]
    local domain = domains[((i - 1) % #domains) + 1]
    local email = string.lower(first_name .. "." .. last_name .. "@" .. domain)
    local salary = 45000 + (i * 123) % 100000  -- Varied salary between 45k-145k
    local hire_year = 2020 + (i % 5)
    local hire_month = ((i - 1) % 12) + 1
    local hire_day = ((i - 1) % 28) + 1
    local hire_date = string.format("%04d-%02d-%02d", hire_year, hire_month, hire_day)
    local active = (i % 7 ~= 0) and "true" or "false"  -- ~85% active
    local score = 65 + (i * 7) % 35  -- Score between 65-100
    
    local row = string.format("%d,%s %s,%s,%s,%d,%s,%s,%.1f", 
      i, first_name, last_name, email, department, salary, hire_date, active, score)
    table.insert(data, row)
  end
  
  return data
end

-- Helper function to create and save temp CSV file
local function create_temp_csv(num_rows, command_name)
  local temp_dir = vim.fn.stdpath("cache") .. "/csv_temp"
  
  -- Create temp directory if it doesn't exist
  if vim.fn.isdirectory(temp_dir) == 0 then
    vim.fn.mkdir(temp_dir, "p")
  end
  
  -- Generate filename with timestamp
  local timestamp = os.date("%Y%m%d_%H%M%S")
  local filename = string.format("test_%dk_rows_%s.csv", math.floor(num_rows/1000), timestamp)
  local filepath = temp_dir .. "/" .. filename
  
  -- Generate CSV data
  vim.notify(string.format("Generating %d rows of CSV data...", num_rows), vim.log.levels.INFO)
  local data = generate_csv_data(num_rows)
  
  -- Create new buffer
  local buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
  
  -- Set buffer name and save
  vim.api.nvim_buf_set_name(buf, filepath)
  vim.api.nvim_buf_set_option(buf, "buftype", "")
  vim.api.nvim_buf_set_option(buf, "filetype", "csv")
  
  -- Save the buffer
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("write")
  end)
  
  -- Open the buffer in current window
  vim.api.nvim_win_set_buf(0, buf)
  
  -- Success message
  local file_size = vim.fn.getfsize(filepath)
  local function format_bytes(bytes)
    if bytes < 1024 then return bytes .. "B"
    elseif bytes < 1024*1024 then return string.format("%.1fKB", bytes/1024)
    else return string.format("%.1fMB", bytes/(1024*1024)) end
  end
  
  vim.notify(string.format("✅ Created %s with %d rows (%s)", 
    filename, num_rows + 1, format_bytes(file_size)), vim.log.levels.INFO)
  
  -- Auto-run Details command if available
  vim.defer_fn(function()
    if vim.fn.exists(":Details") > 0 then
      vim.cmd("Details")
    end
  end, 500)
end

-- Create the commands
vim.api.nvim_create_user_command("Create1000", function()
  create_temp_csv(1000, "Create1000")
end, { desc = "Create temporary CSV file with 1,000 rows" })

vim.api.nvim_create_user_command("Create10000", function()
  create_temp_csv(10000, "Create10000")
end, { desc = "Create temporary CSV file with 10,000 rows" })

vim.api.nvim_create_user_command("Create50000", function()
  create_temp_csv(50000, "Create50000")
end, { desc = "Create temporary CSV file with 50,000 rows" })

vim.api.nvim_create_user_command("Create100000", function()
  create_temp_csv(100000, "Create100000")
end, { desc = "Create temporary CSV file with 100,000 rows" })

-- Bonus: Create a command to clean up temp files
vim.api.nvim_create_user_command("CleanCSVTemp", function()
  local temp_dir = vim.fn.stdpath("cache") .. "/csv_temp"
  if vim.fn.isdirectory(temp_dir) == 1 then
    local files = vim.fn.glob(temp_dir .. "/*.csv", false, true)
    local count = 0
    for _, file in ipairs(files) do
      if vim.fn.delete(file) == 0 then
        count = count + 1
      end
    end
    vim.notify(string.format("🧹 Cleaned up %d temporary CSV files", count), vim.log.levels.INFO)
  else
    vim.notify("No temporary CSV files to clean", vim.log.levels.INFO)
  end
end, { desc = "Clean up temporary CSV test files" })

-- Command to list temp files
vim.api.nvim_create_user_command("ListCSVTemp", function()
  local temp_dir = vim.fn.stdpath("cache") .. "/csv_temp"
  if vim.fn.isdirectory(temp_dir) == 1 then
    local files = vim.fn.glob(temp_dir .. "/*.csv", false, true)
    if #files > 0 then
      vim.notify("📂 Temporary CSV files:", vim.log.levels.INFO)
      for _, file in ipairs(files) do
        local name = vim.fn.fnamemodify(file, ":t")
        local size = vim.fn.getfsize(file)
        local size_str = size < 1024 and (size .. "B") or 
                        size < 1024*1024 and string.format("%.1fKB", size/1024) or
                        string.format("%.1fMB", size/(1024*1024))
        print("  " .. name .. " (" .. size_str .. ")")
      end
    else
      vim.notify("No temporary CSV files found", vim.log.levels.INFO)
    end
  else
    vim.notify("No temporary CSV directory found", vim.log.levels.INFO)
  end
end, { desc = "List temporary CSV test files" })

-- Command to open temp directory in file explorer
vim.api.nvim_create_user_command("OpenCSVTemp", function()
  local temp_dir = vim.fn.stdpath("cache") .. "/csv_temp"
  if vim.fn.isdirectory(temp_dir) == 1 then
    vim.cmd("edit " .. temp_dir)
  else
    vim.notify("Temporary CSV directory doesn't exist yet", vim.log.levels.WARN)
  end
end, { desc = "Open temporary CSV directory" })

-- Add helpful keymaps for CSV testing
vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  callback = function()
    local opts = { buffer = true, silent = true }
    
    -- Quick commands for testing
    vim.keymap.set("n", "<leader>ct", ":Details<CR>", 
      vim.tbl_extend("force", opts, { desc = "CSV Details" }))
    vim.keymap.set("n", "<leader>cT", ":SimpleDetails<CR>", 
      vim.tbl_extend("force", opts, { desc = "Simple CSV Details" }))
    vim.keymap.set("n", "<leader>cL", ":ListCSVTemp<CR>", 
      vim.tbl_extend("force", opts, { desc = "List temp CSV files" }))
  end,
})

-- Show available commands on startup (optional)
vim.defer_fn(function()
  if vim.g.csv_show_commands_on_startup then
    vim.notify("CSV Test Commands: :Create1000 :Create10000 :Create50000 :Create100000", vim.log.levels.INFO)
  end
end, 2000)