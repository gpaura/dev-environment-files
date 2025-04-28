return {
  -- Plugin para detectar arquivos CSV sem extensão e tratá-los como CSV genuínos
  {
    "mechatroner/rainbow_csv", -- Mesmo plugin usado no csv.lua
    lazy = false,
    event = "VeryLazy",
    config = function()
      -- Configura vale.ini para ser completamente desativado
      local disabled_vale_config = [[
# Vale config completamente desativado
MinAlertLevel = error

# Diretório vazio
StylesPath = ""

# Desabilita todos os estilos
[*]
BasedOnStyles =
Ignore = .*
]]

      -- Cria um arquivo vale.ini vazio no diretório atual
      local function create_disabled_vale_config()
        local cwd = vim.fn.getcwd()
        local vale_path = cwd .. "/.vale.ini"
        
        -- Apenas cria se não existir
        if vim.fn.filereadable(vale_path) == 0 then
          vim.fn.writefile(vim.split(disabled_vale_config, "\n"), vale_path)
          vim.notify("📋 Vale desativado para arquivos CSV.", vim.log.levels.INFO)
        end
      end
      
      -- Verifica se é um CSV baseado nos delimitadores comuns
      local function is_csv_file(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        
        -- Verifica até 20 linhas
        local lines = {}
        for i = 1, math.min(20, vim.fn.line("$")) do
          table.insert(lines, vim.fn.getline(i))
        end
        
        -- Pula arquivos muito grandes ou vazios
        if #lines == 0 or vim.fn.line("$") > 10000 then
          return nil
        end
        
        -- Detecta o possível delimitador
        local counts = { [","] = 0, ["|"] = 0, [";"] = 0, ["\t"] = 0 }
        
        -- Conta ocorrências dos delimitadores em várias linhas
        for _, line in ipairs(lines) do
          if line and #line > 0 then
            for delim, _ in pairs(counts) do
              local matches = 0
              local pos = 1
              while true do
                local found = line:find(delim, pos, true)
                if not found then break end
                matches = matches + 1
                pos = found + 1
              end
              -- Apenas conta se tiver pelo menos 2 delimitadores na linha
              counts[delim] = counts[delim] + (matches >= 2 and matches or 0)
            end
          end
        end
        
        -- Verifica qual delimitador é mais comum
        local min_count = 10  -- Mínimo para considerar um CSV
        local max_count = 0
        local detected_delim = nil
        
        for delim, count in pairs(counts) do
          if count > max_count and count >= min_count then
            max_count = count
            detected_delim = delim
          end
        end
        
        return detected_delim
      end
      
      -- Trata o arquivo como CSV e configura tudo
      local function apply_csv_treatment(bufnr, delimiter)
        -- Garante que o Vale esteja desativado
        create_disabled_vale_config()
        
        -- Configura o buffer como CSV
        vim.api.nvim_buf_set_option(bufnr, "filetype", "csv")
        vim.bo[bufnr].fileformat = "unix"
        
        -- Configurações adicionais para melhorar experiência
        vim.bo[bufnr].modifiable = true
        
        -- Mapeamentos de teclas
        vim.keymap.set("n", "<leader>cr", ":RainbowCellGoRight<CR>", { buffer = bufnr, desc = "Next cell" })
        vim.keymap.set("n", "<leader>cl", ":RainbowCellGoLeft<CR>", { buffer = bufnr, desc = "Previous cell" })
        vim.keymap.set("n", "<leader>ca", ":RainbowAlign<CR>", { buffer = bufnr, desc = "Align CSV" })
        vim.keymap.set("n", "<leader>cn", ":RainbowNoAlign<CR>", { buffer = bufnr, desc = "Unalign CSV" })
        
        -- Configura o delimitador no Rainbow CSV
        vim.defer_fn(function()
          if delimiter == "|" then
            vim.cmd([[RainbowDelim "|"]])
          elseif delimiter == ";" then
            vim.cmd([[RainbowDelim ";"]])
          elseif delimiter == "\t" then
            vim.cmd([[RainbowDelim "\t"]])
          else
            vim.cmd([[RainbowDelim ","]])
          end
          
          -- Força a atualização visual
          vim.cmd("syntax sync fromstart")
          vim.cmd("redraw!")
        end, 100)
        
        -- Notifica o usuário
        local delim_names = {[","] = "vírgula", ["|"] = "pipe", [";"] = "ponto e vírgula", ["\t"] = "tab"}
        vim.notify(
          "📊 CSV detectado: delimitador " .. (delim_names[delimiter] or delimiter),
          vim.log.levels.INFO
        )
      end
      
      -- HACK RADICAL: Completamente desativa o Vale LSP
      -- Isso é uma medida extrema para lidar com arquivos sem extensão
      local vale_is_blocked = false
      
      local function block_vale_lsp_completely()
        if vale_is_blocked then return end
        
        -- 1. Desativa o Vale para todas as instâncias existentes
        vim.schedule(function()
          pcall(function()
            for _, client in ipairs(vim.lsp.get_active_clients()) do
              if client.name == "vale_ls" then
                pcall(vim.lsp.stop_client, client.id, true)
                vim.notify("Vale LSP completamente desativado", vim.log.levels.INFO)
              end
            end
          end)
        end)
        
        -- 2. Bloqueia futuras tentativas de iniciar o Vale
        local lspconfig_hooks = {
          'on_new_config',
          'on_attach',
          'on_init',
        }
        
        -- Se o lspconfig estiver carregado, injeta funções para bloquear o Vale
        if package.loaded['lspconfig'] and package.loaded['lspconfig.configs'] then
          local lspconfig = require('lspconfig')
          if lspconfig.configs and lspconfig.configs.vale_ls then
            -- Injeta funções para desativar o Vale
            for _, hook in ipairs(lspconfig_hooks) do
              local original_hook = lspconfig.configs.vale_ls[hook]
              lspconfig.configs.vale_ls[hook] = function(...)
                -- Para arquivos sem extensão, bloqueia o Vale
                local fname = vim.fn.expand("%:t")
                if not fname:match("%..+$") then
                  return false -- Bloqueia a ativação
                end
                
                -- Caso contrário, usa o comportamento original
                if original_hook then
                  return original_hook(...)
                end
              end
            end
          end
        end
        
        vale_is_blocked = true
      end
      
      -- DETECÇÃO DE EXTENSIONLESS CSV
      vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
        pattern = "*",
        callback = function()
          local fname = vim.fn.expand("%:t")
          
          -- Apenas processa arquivos sem extensão
          if not fname:match("%..+$") then
            local bufnr = vim.api.nvim_get_current_buf()
            
            -- Bloqueia o Vale LSP completamente (medida extrema)
            block_vale_lsp_completely()
            
            -- Cria config desabilitado se necessário
            create_disabled_vale_config()
            
            -- Detecta se é um CSV
            local delimiter = is_csv_file(bufnr)
            if delimiter then
              -- Trata como CSV
              apply_csv_treatment(bufnr, delimiter)
            end
          end
        end,
        group = vim.api.nvim_create_augroup("CSVAutodetectRadical", { clear = true })
      })
      
      -- COMANDOS ÚTEIS
      
      -- Comando para forçar tratamento como CSV
      vim.api.nvim_create_user_command("TreatAsCSV", function(opts)
        local delimiter = opts.args
        local bufnr = vim.api.nvim_get_current_buf()
        
        if delimiter == "" or delimiter == "auto" then
          delimiter = is_csv_file() or ","
        elseif delimiter == "comma" then
          delimiter = ","
        elseif delimiter == "pipe" then
          delimiter = "|"
        elseif delimiter == "semicolon" then
          delimiter = ";"
        elseif delimiter == "tab" then
          delimiter = "\t"
        end
        
        -- Bloqueia o Vale LSP completamente
        block_vale_lsp_completely()
        
        -- Aplica tratamento CSV
        apply_csv_treatment(bufnr, delimiter)
      end, { nargs = "?", desc = "Tratar arquivo como CSV", complete = function()
        return {"auto", "comma", "pipe", "semicolon", "tab"}
      end})
      
      -- Comando para salvar como CSV
      vim.api.nvim_create_user_command("SaveAsCSV", function(opts)
        local current_file = vim.fn.expand("%:p")
        local new_file = vim.fn.expand("%:p:r") .. ".csv"
        
        if current_file == new_file then
          vim.notify("O arquivo já tem extensão .csv", vim.log.levels.WARN)
          return
        end
        
        -- Se um arquivo com nome.csv já existir
        if vim.fn.filereadable(new_file) == 1 then
          vim.ui.select({"Sim", "Não"}, {
            prompt = "Arquivo " .. new_file .. " já existe. Sobrescrever?"
          }, function(choice)
            if choice == "Sim" then
              vim.cmd("write " .. vim.fn.fnameescape(new_file))
              vim.cmd("edit " .. vim.fn.fnameescape(new_file))
              vim.notify("Arquivo salvo como " .. new_file, vim.log.levels.INFO)
            end
          end)
        else
          vim.cmd("write " .. vim.fn.fnameescape(new_file))
          vim.cmd("edit " .. vim.fn.fnameescape(new_file))
          vim.notify("Arquivo salvo como " .. new_file, vim.log.levels.INFO)
        end
      end, { desc = "Salvar arquivo como CSV" })
      
      -- Comando para recarregar CSV (em caso de problemas)
      vim.api.nvim_create_user_command("RedetectCSV", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local delimiter = is_csv_file(bufnr)
        
        -- Bloqueia o Vale LSP completamente
        block_vale_lsp_completely()
        
        if delimiter then
          apply_csv_treatment(bufnr, delimiter)
        else
          vim.notify("Não foi possível detectar como CSV. Tente TreatAsCSV", vim.log.levels.WARN)
        end
      end, { desc = "Redetectar CSV" })
    end,
  }
}