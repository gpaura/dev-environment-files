-- ~/.config/nvim/lua/gabriel/plugins/theme-visibility.lua
return {
    -- This is a configuration-only plugin, no actual plugin to install
    {
      "catppuccin/nvim", -- Depend on your existing theme
      config = function()
        -- Function to read WezTerm theme (moved to config scope)
        local function get_wezterm_theme()
          local theme_file = os.getenv("HOME") .. "/.config/wezterm/theme"
          local file = io.open(theme_file, "r")
          if file then
            local theme = file:read("*all")
            file:close()
            return theme:gsub("%s+", "") -- Remove whitespace
          else
            return "light" -- Default fallback
          end
        end

        -- Theme-aware visibility enhancement that checks WezTerm theme
        vim.api.nvim_create_autocmd("ColorScheme", {
          pattern = "*",
          callback = function()
  
            -- Get current theme
            local current_theme = get_wezterm_theme()
            
            -- Define color schemes based on theme
            local colors = {}
            
            if current_theme == "dark" then
              -- Original Dark theme colors - EXACT MATCH with WezTerm dark theme
              colors = {
                background = "#1A1B26",      -- Exact background from dark theme
                normal = "#F8F8F2",          -- Exact foreground from dark theme
                comment = "#565F89",         -- ANSI 8 (bright black) from dark theme
                identifier = "#F8F8F2",      -- Same as normal text
                func = "#BD93F9",            -- ANSI 12 (bright blue) from dark theme
                keyword = "#FF79C6",         -- ANSI 5 (magenta) from dark theme
                string = "#50FA7B",          -- ANSI 2 (green) from dark theme
                number = "#FFB86C",          -- Indexed 16 from dark theme
                operator = "#8BE9FD",        -- ANSI 6 (cyan) from dark theme
                type = "#BD93F9",            -- Same as functions
                variable = "#F8F8F2",        -- Same as normal text
                variable_builtin = "#FF79C6", -- Same as keywords
                variable_param = "#F7768E",  -- ANSI 9 (bright red) from dark theme
                property = "#F8F8F2",        -- Same as normal text
                punctuation = "#ACAAB6",     -- ANSI 7 (white) from dark theme
                line_nr = "#565F89",         -- ANSI 8 (bright black) from dark theme
                cursor_line_nr = "#FF79C6",  -- Magenta for current line
                visual_bg = "#44475A",       -- Selection background from dark theme
                search_bg = "#FF79C6",       -- Magenta background for search
                error = "#FF5555",           -- ANSI 1 (red) from dark theme
                warning = "#A9FF68",         -- ANSI 10 (bright green) from dark theme
                info = "#7AA2F7",            -- ANSI 4 (blue) from dark theme
              }
            elseif current_theme == "lgbt_dark" then
              -- LGBT Dark Rainbow theme colors - EXACT MATCH with WezTerm lgbt_dark_theme
              colors = {
                background = "#0A0A0F",      -- Very dark blue-black from lgbt_dark_theme
                normal = "#F8F9FA",          -- Soft white from rainbow_extended.soft_white
                comment = "#9E9E9E",         -- Medium gray from rainbow_extended.medium_gray
                identifier = "#F8F9FA",      -- Same as normal text
                func = "#BA68C8",            -- Light purple (rainbow_extended.light_purple)
                keyword = "#732982",         -- Pride purple (rainbow_extended.pride_purple)
                string = "#81C784",          -- Light green (rainbow_extended.light_green)
                number = "#FFB347",          -- Light orange (rainbow_extended.light_orange)
                operator = "#FF8C00",        -- Pride orange (rainbow_extended.pride_orange)
                type = "#64B5F6",            -- Light blue (rainbow_extended.light_blue)
                variable = "#F8F9FA",        -- Same as normal text
                variable_builtin = "#732982", -- Pride purple
                variable_param = "#FF6B6B",  -- Light red (rainbow_extended.light_red)
                property = "#FFF176",        -- Light yellow (rainbow_extended.light_yellow)
                punctuation = "#E0E0E0",     -- Light gray (rainbow_extended.light_gray)
                line_nr = "#9E9E9E",         -- Medium gray
                cursor_line_nr = "#BA68C8",  -- Light purple for current line
                visual_bg = "#2D1B4E",       -- Dark purple selection from lgbt_dark_theme
                search_bg = "#732982",       -- Pride purple background for search
                error = "#E40303",           -- Pride red (rainbow_extended.pride_red)
                warning = "#FFED00",         -- Pride yellow (rainbow_extended.pride_yellow)
                info = "#004CFF",            -- Pride blue (rainbow_extended.pride_blue)
              }
            elseif current_theme == "light" then
              -- Original Light theme colors - EXACT MATCH with WezTerm light theme
              colors = {
                background = "#FAFAFA",      -- Exact background from light theme
                normal = "#2D2A2E",          -- Exact foreground from light theme
                comment = "#7A686E",         -- ANSI 8 (bright black) from light theme
                identifier = "#2D2A2E",      -- Same as normal text
                func = "#9D50FF",            -- ANSI 4 (blue) from light theme
                keyword = "#FF3388",         -- ANSI 5 (magenta) from light theme
                string = "#0000FF",          -- ANSI 2 (green) from light theme
                number = "#F26F22",          -- ANSI 1 (red) from light theme
                operator = "#19B3CD",        -- ANSI 6 (cyan) from light theme
                type = "#A64DFF",            -- ANSI 7 (white) from light theme
                variable = "#2D2A2E",        -- Same as normal text
                variable_builtin = "#9D50FF", -- Same as functions
                variable_param = "#FF3388",  -- Same as keywords
                property = "#2D2A2E",        -- Same as normal text
                punctuation = "#5A5257",     -- ANSI 0 (black) from light theme
                line_nr = "#7A686E",         -- ANSI 8 (bright black) from light theme
                cursor_line_nr = "#FF2D76",  -- Cursor color from light theme
                visual_bg = "#E0E0E0",       -- Selection background from light theme
                search_bg = "#FF40A3",       -- ANSI 3 (yellow) from light theme
                error = "#F5623D",           -- ANSI 9 (bright red) from light theme
                warning = "#4E9F2F",         -- ANSI 10 (bright green) from light theme
                info = "#B77BFF",            -- ANSI 12 (bright blue) from light theme
              }
            elseif current_theme == "lgbt_light" then
              -- LGBT Light Rainbow theme colors - EXACT MATCH with WezTerm lgbt_light_theme
              colors = {
                background = "#FEFEFE",      -- Pure white from lgbt_light_theme
                normal = "#1A1A1A",          -- Very dark text from lgbt_light_theme
                comment = "#424242",         -- Dark gray (rainbow_extended.dark_gray)
                identifier = "#1A1A1A",      -- Same as normal text
                func = "#4A148C",            -- Dark purple (rainbow_extended.dark_purple)
                keyword = "#732982",         -- Pride purple for keywords
                string = "#2E7D32",          -- Dark green (rainbow_extended.dark_green)
                number = "#E65100",          -- Dark orange (rainbow_extended.dark_orange)
                operator = "#C62828",        -- Dark red (rainbow_extended.dark_red)
                type = "#1565C0",            -- Dark blue (rainbow_extended.dark_blue)
                variable = "#1A1A1A",        -- Same as normal text
                variable_builtin = "#4A148C", -- Dark purple
                variable_param = "#C62828",  -- Dark red for parameters
                property = "#F57F17",        -- Dark yellow (rainbow_extended.dark_yellow)
                punctuation = "#212121",     -- Soft black (rainbow_extended.soft_black)
                line_nr = "#424242",         -- Dark gray
                cursor_line_nr = "#732982",  -- Pride purple for current line
                visual_bg = "#E1BEE7",       -- Light purple selection from lgbt_light_theme
                search_bg = "#732982",       -- Pride purple background for search
                error = "#E40303",           -- Pride red (rainbow_extended.pride_red)
                warning = "#F57F17",         -- Dark yellow (rainbow_extended.dark_yellow)
                info = "#004CFF",            -- Pride blue (rainbow_extended.pride_blue)
              }
            else
              -- Fallback to original dark theme
              colors = {
                background = "#1A1B26",
                normal = "#F8F8F2",
                comment = "#565F89",
                identifier = "#F8F8F2",
                func = "#BD93F9",
                keyword = "#FF79C6",
                string = "#50FA7B",
                number = "#FFB86C",
                operator = "#8BE9FD",
                type = "#BD93F9",
                variable = "#F8F8F2",
                variable_builtin = "#FF79C6",
                variable_param = "#F7768E",
                property = "#F8F8F2",
                punctuation = "#ACAAB6",
                line_nr = "#565F89",
                cursor_line_nr = "#FF79C6",
                visual_bg = "#44475A",
                search_bg = "#FF79C6",
                error = "#FF5555",
                warning = "#A9FF68",
                info = "#7AA2F7",
              }
            end
  
            -- Apply the color scheme with exact terminal matching INCLUDING BACKGROUND
            local highlight_commands = string.format([[
              " Set the exact background color to match terminal
              highlight Normal gui=bold guifg=%s guibg=%s
              highlight NormalFloat gui=bold guifg=%s guibg=%s
              highlight NormalNC gui=bold guifg=%s guibg=%s
              
              " Base syntax highlighting - exact terminal colors
              highlight Comment gui=bold guifg=%s
              highlight Identifier gui=bold guifg=%s
              highlight Function gui=bold guifg=%s
              highlight Keyword gui=bold guifg=%s
              highlight String gui=bold guifg=%s
              highlight Number gui=bold guifg=%s
              highlight Operator gui=bold guifg=%s
              highlight Type gui=bold guifg=%s
              highlight Constant gui=bold guifg=%s
              highlight PreProc gui=bold guifg=%s
              highlight Special gui=bold guifg=%s
              
              " TreeSitter highlights - matching terminal colors
              highlight @variable gui=bold guifg=%s
              highlight @variable.builtin gui=bold guifg=%s
              highlight @variable.parameter gui=bold guifg=%s
              highlight @variable.member gui=bold guifg=%s
              highlight @keyword gui=bold guifg=%s
              highlight @keyword.function gui=bold guifg=%s
              highlight @keyword.operator gui=bold guifg=%s
              highlight @keyword.return gui=bold guifg=%s
              highlight @keyword.conditional gui=bold guifg=%s
              highlight @keyword.repeat gui=bold guifg=%s
              highlight @function gui=bold guifg=%s
              highlight @function.builtin gui=bold guifg=%s
              highlight @function.call gui=bold guifg=%s
              highlight @method gui=bold guifg=%s
              highlight @method.call gui=bold guifg=%s
              highlight @property gui=bold guifg=%s
              highlight @field gui=bold guifg=%s
              highlight @punctuation gui=bold guifg=%s
              highlight @punctuation.bracket gui=bold guifg=%s
              highlight @punctuation.delimiter gui=bold guifg=%s
              highlight @string gui=bold guifg=%s
              highlight @string.escape gui=bold guifg=%s
              highlight @number gui=bold guifg=%s
              highlight @boolean gui=bold guifg=%s
              highlight @type gui=bold guifg=%s
              highlight @type.builtin gui=bold guifg=%s
              
              " LSP semantic tokens - exact terminal color mapping
              highlight @lsp.type.variable gui=bold guifg=%s
              highlight @lsp.type.function gui=bold guifg=%s
              highlight @lsp.type.method gui=bold guifg=%s
              highlight @lsp.type.property gui=bold guifg=%s
              highlight @lsp.type.parameter gui=bold guifg=%s
              highlight @lsp.type.keyword gui=bold guifg=%s
              highlight @lsp.type.type gui=bold guifg=%s
              
              " UI elements - exact terminal color mapping
              highlight LineNr gui=bold guifg=%s guibg=%s
              highlight CursorLineNr gui=bold guifg=%s guibg=%s
              highlight Visual gui=bold guibg=%s guifg=%s
              highlight Search gui=bold guibg=%s guifg=#FFFFFF
              highlight IncSearch gui=bold guibg=%s guifg=#FFFFFF
              
              " Diagnostic colors - matching terminal colors
              highlight DiagnosticError gui=bold guifg=%s
              highlight DiagnosticWarn gui=bold guifg=%s
              highlight DiagnosticInfo gui=bold guifg=%s
              highlight DiagnosticHint gui=bold guifg=%s
              
              " Additional syntax elements for completeness
              highlight Statement gui=bold guifg=%s
              highlight Conditional gui=bold guifg=%s
              highlight Repeat gui=bold guifg=%s
              highlight Label gui=bold guifg=%s
              highlight Exception gui=bold guifg=%s
              highlight Include gui=bold guifg=%s
              highlight Define gui=bold guifg=%s
              highlight Macro gui=bold guifg=%s
              highlight PreCondit gui=bold guifg=%s
              highlight StorageClass gui=bold guifg=%s
              highlight Structure gui=bold guifg=%s
              highlight Typedef gui=bold guifg=%s
              highlight Tag gui=bold guifg=%s
              highlight Delimiter gui=bold guifg=%s
              highlight SpecialComment gui=bold guifg=%s
              highlight Debug gui=bold guifg=%s
              
              " Ensure transparent background is disabled when we set specific colors
              highlight EndOfBuffer gui=bold guifg=%s guibg=%s
              highlight SignColumn gui=bold guibg=%s
              highlight FoldColumn gui=bold guibg=%s
              highlight ColorColumn gui=bold guibg=%s
            ]],
              -- Background settings - MOST IMPORTANT
              colors.normal, colors.background,    -- Normal
              colors.normal, colors.background,    -- NormalFloat  
              colors.normal, colors.background,    -- NormalNC
              
              -- Basic highlights - exact terminal color mapping
              colors.comment,     -- Comment  
              colors.identifier,  -- Identifier
              colors.func,        -- Function
              colors.keyword,     -- Keyword
              colors.string,      -- String
              colors.number,      -- Number
              colors.operator,    -- Operator
              colors.type,        -- Type
              colors.number,      -- Constant
              colors.operator,    -- PreProc
              colors.keyword,     -- Special
              
              -- TreeSitter highlights - exact terminal color mapping
              colors.variable,        -- @variable
              colors.variable_builtin, -- @variable.builtin
              colors.variable_param,  -- @variable.parameter
              colors.property,        -- @variable.member
              colors.keyword,         -- @keyword
              colors.func,           -- @keyword.function
              colors.operator,       -- @keyword.operator
              colors.keyword,        -- @keyword.return
              colors.keyword,        -- @keyword.conditional
              colors.keyword,        -- @keyword.repeat
              colors.func,           -- @function
              colors.func,           -- @function.builtin
              colors.func,           -- @function.call
              colors.func,           -- @method
              colors.func,           -- @method.call
              colors.property,       -- @property
              colors.property,       -- @field
              colors.punctuation,    -- @punctuation
              colors.punctuation,    -- @punctuation.bracket
              colors.punctuation,    -- @punctuation.delimiter
              colors.string,         -- @string
              colors.number,         -- @string.escape
              colors.number,         -- @number
              colors.number,         -- @boolean
              colors.type,           -- @type
              colors.type,           -- @type.builtin
              
              -- LSP semantic tokens - exact terminal color mapping
              colors.variable,       -- @lsp.type.variable
              colors.func,           -- @lsp.type.function
              colors.func,           -- @lsp.type.method
              colors.property,       -- @lsp.type.property
              colors.variable_param, -- @lsp.type.parameter
              colors.keyword,        -- @lsp.type.keyword
              colors.type,           -- @lsp.type.type
              
              -- UI elements - exact terminal color mapping
              colors.line_nr, colors.background,        -- LineNr
              colors.cursor_line_nr, colors.background, -- CursorLineNr
              colors.visual_bg,      -- Visual background
              colors.normal,         -- Visual foreground
              colors.search_bg,      -- Search background
              colors.search_bg,      -- IncSearch background
              
              -- Diagnostics - exact terminal color mapping
              colors.error,          -- DiagnosticError
              colors.warning,        -- DiagnosticWarn
              colors.info,           -- DiagnosticInfo
              colors.comment,        -- DiagnosticHint
              
              -- Additional syntax elements using exact terminal colors
              colors.keyword,        -- Statement
              colors.keyword,        -- Conditional
              colors.keyword,        -- Repeat
              colors.keyword,        -- Label
              colors.keyword,        -- Exception
              colors.operator,       -- Include
              colors.operator,       -- Define
              colors.operator,       -- Macro
              colors.operator,       -- PreCondit
              colors.type,           -- StorageClass
              colors.type,           -- Structure
              colors.type,           -- Typedef
              colors.func,           -- Tag
              colors.punctuation,    -- Delimiter
              colors.comment,        -- SpecialComment
              colors.error,          -- Debug
              
              -- Background consistency
              colors.comment, colors.background,  -- EndOfBuffer
              colors.background,                  -- SignColumn
              colors.background,                  -- FoldColumn
              colors.background                   -- ColorColumn
            )
  
            vim.cmd(highlight_commands)
            
            -- Also set vim options to ensure background is correct
            if current_theme == "dark" or current_theme == "lgbt_dark" then
              vim.opt.background = "dark"
            elseif current_theme == "light" or current_theme == "lgbt_light" then
              vim.opt.background = "light"
            else
              vim.opt.background = "dark" -- fallback
            end
            
            -- Notify about theme change (optional - remove if annoying)
            -- vim.notify("Applied " .. current_theme .. " theme colors (including background) to Neovim", vim.log.levels.INFO)
          end,
        })
  
        -- Function to manually refresh theme colors
        local function refresh_theme_colors()
          vim.cmd([[doautocmd ColorScheme]])
        end
  
        -- Create a command to manually refresh colors
        vim.api.nvim_create_user_command("RefreshThemeColors", refresh_theme_colors, {
          desc = "Refresh theme colors based on current WezTerm theme"
        })

        -- Auto-refresh theme when switching back to nvim or when file changes
        local last_theme = get_wezterm_theme()
        
        vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "WinEnter"}, {
          group = vim.api.nvim_create_augroup("ThemeAutoSync", { clear = true }),
          callback = function()
            local current_theme = get_wezterm_theme()
            if current_theme ~= last_theme then
              last_theme = current_theme
              refresh_theme_colors()
              vim.notify("Theme synced: " .. current_theme, vim.log.levels.INFO, {
                title = "Theme Auto-Sync",
                timeout = 1500,
              })
            end
          end,
        })

        -- Also check periodically (every 2 seconds when focused)
        local timer = vim.loop.new_timer()
        timer:start(2000, 2000, vim.schedule_wrap(function()
          if vim.api.nvim_get_mode().mode ~= "i" then -- Don't interrupt insert mode
            local current_theme = get_wezterm_theme()
            if current_theme ~= last_theme then
              last_theme = current_theme
              refresh_theme_colors()
            end
          end
        end))
  
        -- Apply immediately when this config loads
        vim.schedule(function()
          vim.cmd([[doautocmd ColorScheme]])
        end)
      end,
    }
  }