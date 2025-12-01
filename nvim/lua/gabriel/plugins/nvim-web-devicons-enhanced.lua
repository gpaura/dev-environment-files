return {
  "nvim-tree/nvim-web-devicons",
  config = function()
    local icons = require('nvim-web-devicons')

    -- Enhanced icon configuration with perfect icons for 50+ most used file types
    icons.setup({
      -- Enable color icons across all tools
      color_icons = true,
      default = true,
      strict = true,

      -- Perfect icons for the most commonly used file types
      override = {
        -- ============================================================
        -- PROGRAMMING LANGUAGES (Most Popular)
        -- ============================================================

        -- JavaScript Ecosystem
        js = {
          icon = "󰌞",
          color = "#F7DF1E",
          name = "JavaScript"
        },
        jsx = {
          icon = "󰜈",
          color = "#61DAFB",
          name = "React"
        },
        mjs = {
          icon = "󰌞",
          color = "#F7DF1E",
          name = "JavaScriptModule"
        },
        cjs = {
          icon = "󰌞",
          color = "#F7DF1E",
          name = "JavaScriptCommon"
        },

        -- TypeScript Ecosystem
        ts = {
          icon = "󰛦",
          color = "#3178C6",
          name = "TypeScript"
        },
        tsx = {
          icon = "󰜈",
          color = "#61DAFB",
          name = "ReactTypeScript"
        },

        -- Python
        py = {
          icon = "󰌠",
          color = "#3776AB",
          name = "Python"
        },
        pyc = {
          icon = "󰌠",
          color = "#6C9ECA",
          name = "PythonCompiled"
        },
        pyo = {
          icon = "󰌠",
          color = "#6C9ECA",
          name = "PythonOptimized"
        },
        pyd = {
          icon = "󰌠",
          color = "#6C9ECA",
          name = "PythonDLL"
        },

        -- Go
        go = {
          icon = "󰟓",
          color = "#00ADD8",
          name = "Go"
        },

        -- Rust
        rs = {
          icon = "󱘗",
          color = "#CE422B",
          name = "Rust"
        },

        -- Java/Kotlin
        java = {
          icon = "󰬈",
          color = "#ED8B00",
          name = "Java"
        },
        class = {
          icon = "󰬈",
          color = "#ED8B00",
          name = "JavaClass"
        },
        jar = {
          icon = "󰬈",
          color = "#ED8B00",
          name = "JavaArchive"
        },
        kt = {
          icon = "󱈙",
          color = "#7F52FF",
          name = "Kotlin"
        },

        -- C/C++
        c = {
          icon = "󰙱",
          color = "#A8B9CC",
          name = "C"
        },
        cpp = {
          icon = "󰙲",
          color = "#00599C",
          name = "CPlusPlus"
        },
        h = {
          icon = "󰙱",
          color = "#A8B9CC",
          name = "CHeader"
        },
        hpp = {
          icon = "󰙲",
          color = "#00599C",
          name = "CPlusPlusHeader"
        },

        -- C#
        cs = {
          icon = "󰌛",
          color = "#239120",
          name = "CSharp"
        },

        -- PHP
        php = {
          icon = "󰌟",
          color = "#777BB4",
          name = "PHP"
        },

        -- Ruby
        rb = {
          icon = "󰴭",
          color = "#CC342D",
          name = "Ruby"
        },

        -- Swift
        swift = {
          icon = "󰛥",
          color = "#F05138",
          name = "Swift"
        },

        -- Lua
        lua = {
          icon = "󰢱",
          color = "#51A0CF",
          name = "Lua"
        },

        -- Vim
        vim = {
          icon = "",
          color = "#019733",
          name = "Vim"
        },

        -- ============================================================
        -- WEB TECHNOLOGIES
        -- ============================================================

        -- HTML
        html = {
          icon = "󰌝",
          color = "#E34F26",
          name = "HTML"
        },
        htm = {
          icon = "󰌝",
          color = "#E34F26",
          name = "HTML"
        },

        -- CSS & Preprocessors
        css = {
          icon = "󰌜",
          color = "#1572B6",
          name = "CSS"
        },
        scss = {
          icon = "󰟬",
          color = "#CF649A",
          name = "SCSS"
        },
        sass = {
          icon = "󰟬",
          color = "#CF649A",
          name = "SASS"
        },
        less = {
          icon = "󰌜",
          color = "#1D365D",
          name = "Less"
        },

        -- Frontend Frameworks
        vue = {
          icon = "󰡄",
          color = "#4FC08D",
          name = "Vue"
        },
        svelte = {
          icon = "󰡄",
          color = "#FF3E00",
          name = "Svelte"
        },
        astro = {
          icon = "󱓞",
          color = "#FF5D01",
          name = "Astro"
        },

        -- ============================================================
        -- CONFIGURATION & DATA FILES
        -- ============================================================

        -- JSON
        json = {
          icon = "󰘦",
          color = "#CBCB41",
          name = "JSON"
        },
        jsonc = {
          icon = "󰘦",
          color = "#CBCB41",
          name = "JSONWithComments"
        },
        json5 = {
          icon = "󰘦",
          color = "#CBCB41",
          name = "JSON5"
        },

        -- YAML
        yaml = {
          icon = "󰈙",
          color = "#CB171E",
          name = "YAML"
        },
        yml = {
          icon = "󰈙",
          color = "#CB171E",
          name = "YAML"
        },

        -- TOML
        toml = {
          icon = "󰈙",
          color = "#9C4221",
          name = "TOML"
        },

        -- XML
        xml = {
          icon = "󰗀",
          color = "#E37933",
          name = "XML"
        },

        -- INI
        ini = {
          icon = "󰈙",
          color = "#6D8086",
          name = "INI"
        },

        -- ============================================================
        -- DOCUMENTATION
        -- ============================================================

        -- Markdown
        md = {
          icon = "󰍔",
          color = "#519ABA",
          name = "Markdown"
        },
        mdx = {
          icon = "󰍔",
          color = "#519ABA",
          name = "MDX"
        },

        -- Text & Documentation
        txt = {
          icon = "󰈙",
          color = "#89E051",
          name = "Text"
        },
        pdf = {
          icon = "󰈦",
          color = "#F40F02",
          name = "PDF"
        },
        doc = {
          icon = "󰈬",
          color = "#2B579A",
          name = "Word"
        },
        docx = {
          icon = "󰈬",
          color = "#2B579A",
          name = "Word"
        },

        -- ============================================================
        -- SHELL & SCRIPTS
        -- ============================================================

        sh = {
          icon = "󰆍",
          color = "#4EAA25",
          name = "Shell"
        },
        bash = {
          icon = "󰆍",
          color = "#4EAA25",
          name = "Bash"
        },
        zsh = {
          icon = "󰆍",
          color = "#89E051",
          name = "Zsh"
        },
        fish = {
          icon = "󰈺",
          color = "#4AAE47",
          name = "Fish"
        },
        nu = {
          icon = "󰆍",
          color = "#4FBF5D",
          name = "Nushell"
        },
        ps1 = {
          icon = "󰨊",
          color = "#012456",
          name = "PowerShell"
        },

        -- ============================================================
        -- BUILD & PACKAGE MANAGERS
        -- ============================================================

        -- npm/Node
        ["package.json"] = {
          icon = "󰎙",
          color = "#E8274B",
          name = "PackageJson"
        },
        ["package-lock.json"] = {
          icon = "󰎙",
          color = "#7A2048",
          name = "PackageLockJson"
        },
        ["yarn.lock"] = {
          icon = "󰎙",
          color = "#2C8EBB",
          name = "YarnLock"
        },
        ["pnpm-lock.yaml"] = {
          icon = "󰎙",
          color = "#F69220",
          name = "PnpmLock"
        },

        -- Rust
        ["cargo.toml"] = {
          icon = "󱘗",
          color = "#CE422B",
          name = "CargoToml"
        },
        ["cargo.lock"] = {
          icon = "󱘗",
          color = "#CE422B",
          name = "CargoLock"
        },

        -- Go
        ["go.mod"] = {
          icon = "󰟓",
          color = "#00ADD8",
          name = "GoMod"
        },
        ["go.sum"] = {
          icon = "󰟓",
          color = "#00ADD8",
          name = "GoSum"
        },

        -- Python
        ["requirements.txt"] = {
          icon = "󰌠",
          color = "#3776AB",
          name = "Requirements"
        },
        ["pyproject.toml"] = {
          icon = "󰌠",
          color = "#3776AB",
          name = "PyProject"
        },
        ["setup.py"] = {
          icon = "󰌠",
          color = "#3776AB",
          name = "SetupPy"
        },

        -- Ruby
        ["gemfile"] = {
          icon = "󰴭",
          color = "#CC342D",
          name = "Gemfile"
        },
        ["gemfile.lock"] = {
          icon = "󰴭",
          color = "#CC342D",
          name = "GemfileLock"
        },

        -- Maven/Gradle
        ["pom.xml"] = {
          icon = "󰬈",
          color = "#ED8B00",
          name = "Maven"
        },
        ["build.gradle"] = {
          icon = "󰬈",
          color = "#02303A",
          name = "Gradle"
        },

        -- ============================================================
        -- DOCKER & CONTAINERS
        -- ============================================================

        dockerfile = {
          icon = "󰡨",
          color = "#0DB7ED",
          name = "Docker"
        },
        ["dockerfile"] = {
          icon = "󰡨",
          color = "#0DB7ED",
          name = "Docker"
        },
        [".dockerignore"] = {
          icon = "󰡨",
          color = "#0DB7ED",
          name = "DockerIgnore"
        },
        ["docker-compose.yml"] = {
          icon = "󰡨",
          color = "#0DB7ED",
          name = "DockerCompose"
        },

        -- ============================================================
        -- VERSION CONTROL
        -- ============================================================

        [".gitignore"] = {
          icon = "󰊢",
          color = "#F34F29",
          name = "GitIgnore"
        },
        [".gitmodules"] = {
          icon = "󰊢",
          color = "#F34F29",
          name = "GitModules"
        },
        [".gitattributes"] = {
          icon = "󰊢",
          color = "#F34F29",
          name = "GitAttributes"
        },
        [".gitconfig"] = {
          icon = "󰊢",
          color = "#F34F29",
          name = "GitConfig"
        },

        -- ============================================================
        -- DATABASES
        -- ============================================================

        sql = {
          icon = "󰆼",
          color = "#E8274B",
          name = "SQL"
        },
        db = {
          icon = "󰆼",
          color = "#DAD8D8",
          name = "Database"
        },
        sqlite = {
          icon = "󰆼",
          color = "#003B57",
          name = "SQLite"
        },
        sqlite3 = {
          icon = "󰆼",
          color = "#003B57",
          name = "SQLite3"
        },

        -- ============================================================
        -- MEDIA FILES
        -- ============================================================

        -- Images
        png = {
          icon = "󰈟",
          color = "#A074C4",
          name = "PNG"
        },
        jpg = {
          icon = "󰈟",
          color = "#A074C4",
          name = "JPEG"
        },
        jpeg = {
          icon = "󰈟",
          color = "#A074C4",
          name = "JPEG"
        },
        gif = {
          icon = "󰵸",
          color = "#A074C4",
          name = "GIF"
        },
        svg = {
          icon = "󰜡",
          color = "#FFB13B",
          name = "SVG"
        },
        ico = {
          icon = "󰈟",
          color = "#CBCB41",
          name = "ICO"
        },
        webp = {
          icon = "󰈟",
          color = "#A074C4",
          name = "WebP"
        },

        -- Video
        mp4 = {
          icon = "󰕧",
          color = "#FD971F",
          name = "MP4"
        },
        mkv = {
          icon = "󰕧",
          color = "#FD971F",
          name = "MKV"
        },
        avi = {
          icon = "󰕧",
          color = "#FD971F",
          name = "AVI"
        },
        mov = {
          icon = "󰕧",
          color = "#FD971F",
          name = "MOV"
        },

        -- Audio
        mp3 = {
          icon = "󰎆",
          color = "#00D9FF",
          name = "MP3"
        },
        wav = {
          icon = "󰎆",
          color = "#00D9FF",
          name = "WAV"
        },
        flac = {
          icon = "󰎆",
          color = "#00D9FF",
          name = "FLAC"
        },

        -- ============================================================
        -- ARCHIVES
        -- ============================================================

        zip = {
          icon = "󰗄",
          color = "#F9DC3E",
          name = "Zip"
        },
        rar = {
          icon = "󰗄",
          color = "#F9DC3E",
          name = "Rar"
        },
        ["7z"] = {
          icon = "󰗄",
          color = "#F9DC3E",
          name = "7z"
        },
        tar = {
          icon = "󰗄",
          color = "#F9DC3E",
          name = "Tar"
        },
        gz = {
          icon = "󰗄",
          color = "#F9DC3E",
          name = "Gzip"
        },
        bz2 = {
          icon = "󰗄",
          color = "#F9DC3E",
          name = "Bzip2"
        },

        -- ============================================================
        -- LOGS & TEMP FILES
        -- ============================================================

        log = {
          icon = "󰌱",
          color = "#AFABA6",
          name = "Log"
        },

        -- ============================================================
        -- ENVIRONMENT & CONFIG
        -- ============================================================

        [".env"] = {
          icon = "󰙪",
          color = "#FBD52D",
          name = "Environment"
        },
        [".env.local"] = {
          icon = "󰙪",
          color = "#FBD52D",
          name = "EnvironmentLocal"
        },
        [".env.development"] = {
          icon = "󰙪",
          color = "#FBD52D",
          name = "EnvironmentDev"
        },
        [".env.production"] = {
          icon = "󰙪",
          color = "#FBD52D",
          name = "EnvironmentProd"
        },
        [".env.example"] = {
          icon = "󰙪",
          color = "#E8E089",
          name = "EnvironmentExample"
        },

        -- ============================================================
        -- LINTERS & FORMATTERS
        -- ============================================================

        [".editorconfig"] = {
          icon = "󰷐",
          color = "#E8274B",
          name = "EditorConfig"
        },
        [".prettierrc"] = {
          icon = "󰬗",
          color = "#F7B93E",
          name = "Prettier"
        },
        [".prettierignore"] = {
          icon = "󰬗",
          color = "#F7B93E",
          name = "PrettierIgnore"
        },
        [".eslintrc"] = {
          icon = "󰱺",
          color = "#4B32C3",
          name = "ESLint"
        },
        [".eslintrc.js"] = {
          icon = "󰱺",
          color = "#4B32C3",
          name = "ESLint"
        },
        [".eslintrc.json"] = {
          icon = "󰱺",
          color = "#4B32C3",
          name = "ESLint"
        },
        [".eslintignore"] = {
          icon = "󰱺",
          color = "#4B32C3",
          name = "ESLintIgnore"
        },
        [".babelrc"] = {
          icon = "󰨥",
          color = "#F9DC3E",
          name = "Babel"
        },

        -- ============================================================
        -- SPECIAL FILES
        -- ============================================================

        license = {
          icon = "󰿃",
          color = "#CBCB41",
          name = "License"
        },
        ["license"] = {
          icon = "󰿃",
          color = "#CBCB41",
          name = "License"
        },
        readme = {
          icon = "󰍔",
          color = "#4FC08D",
          name = "README"
        },
        ["readme.md"] = {
          icon = "󰍔",
          color = "#4FC08D",
          name = "README"
        },
        changelog = {
          icon = "󰷐",
          color = "#8FAA54",
          name = "Changelog"
        },
        ["changelog.md"] = {
          icon = "󰷐",
          color = "#8FAA54",
          name = "Changelog"
        },
        makefile = {
          icon = "󱁤",
          color = "#6D8086",
          name = "Makefile"
        },
        ["makefile"] = {
          icon = "󱁤",
          color = "#6D8086",
          name = "Makefile"
        },

        -- ============================================================
        -- CI/CD
        -- ============================================================

        [".gitlab-ci.yml"] = {
          icon = "󰮠",
          color = "#E24329",
          name = "GitLabCI"
        },
        [".travis.yml"] = {
          icon = "󰜫",
          color = "#B83D3E",
          name = "TravisCI"
        },
        ["jenkinsfile"] = {
          icon = "󰜫",
          color = "#D24939",
          name = "Jenkins"
        },
      },

      -- Enhanced by file extension mappings
      override_by_extension = {
        ["log"] = {
          icon = "󰌱",
          color = "#81C784",
          name = "Log"
        },
        ["tmp"] = {
          icon = "󰯃",
          color = "#6C6C6C",
          name = "Temporary"
        },
        ["bak"] = {
          icon = "󰁯",
          color = "#6C6C6C",
          name = "Backup"
        },
        ["swp"] = {
          icon = "󰁯",
          color = "#6C6C6C",
          name = "Swap"
        },
      },

      -- Enhanced folder icon mappings (Monokai Pro Octagon colors)
      override_by_filename = {
        [".github"] = {
          icon = "",
          color = "#FF6188",
          name = "GitHubFolder"
        },
        ["node_modules"] = {
          icon = "",
          color = "#A9DC76",
          name = "NodeModules"
        },
        [".git"] = {
          icon = "",
          color = "#FC9867",
          name = "GitFolder"
        },
        ["src"] = {
          icon = "󰉋",
          color = "#78DCE8",
          name = "SourceFolder"
        },
        ["test"] = {
          icon = "󰙨",
          color = "#AB9DF2",
          name = "TestFolder"
        },
        ["tests"] = {
          icon = "󰙨",
          color = "#AB9DF2",
          name = "TestsFolder"
        },
        ["__tests__"] = {
          icon = "󰙨",
          color = "#AB9DF2",
          name = "TestsFolder"
        },
        ["docs"] = {
          icon = "󰈙",
          color = "#FFD866",
          name = "DocsFolder"
        },
        ["build"] = {
          icon = "󰏗",
          color = "#FC9867",
          name = "BuildFolder"
        },
        ["dist"] = {
          icon = "󰏗",
          color = "#FC9867",
          name = "DistFolder"
        },
        ["config"] = {
          icon = "",
          color = "#FFD866",
          name = "ConfigFolder"
        },
        [".config"] = {
          icon = "",
          color = "#FFD866",
          name = "ConfigFolder"
        },
        ["public"] = {
          icon = "󰉋",
          color = "#A9DC76",
          name = "PublicFolder"
        },
        ["assets"] = {
          icon = "󰉏",
          color = "#FC9867",
          name = "AssetsFolder"
        },
        ["images"] = {
          icon = "󰉏",
          color = "#FF6188",
          name = "ImagesFolder"
        },
        ["components"] = {
          icon = "󰡀",
          color = "#78DCE8",
          name = "ComponentsFolder"
        },
        ["lib"] = {
          icon = "󰫮",
          color = "#AB9DF2",
          name = "LibFolder"
        },
        ["utils"] = {
          icon = "󰘧",
          color = "#FFD866",
          name = "UtilsFolder"
        },
        ["scripts"] = {
          icon = "󰥨",
          color = "#A9DC76",
          name = "ScriptsFolder"
        },
      },
    })

    -- Force icon refresh across all components
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd('doautocmd BufRead')
      end)
    end)
  end,
}