# lf Icons - Matches Neovim File Explorer

This configuration matches your nvim-tree and nvim-web-devicons setup exactly.

## Key Icon Mappings

### Default Types
- 󰉋 Directories (folders)
- 󰈚 Regular files
- 󰌷 Symbolic links

### Programming Languages
- 󰌞 JavaScript (`.js`, `.mjs`, `.cjs`)
- 󰜈 React (`.jsx`, `.tsx`)
- 󰛦 TypeScript (`.ts`)
- 󰌠 Python (`.py`, `.pyc`, `.pyo`, `.pyd`)
- 󰟓 Go (`.go`, `go.mod`, `go.sum`)
- 󱘗 Rust (`.rs`, `cargo.toml`, `cargo.lock`)
- 󰬈 Java (`.java`, `.class`, `.jar`)
- 󱈙 Kotlin (`.kt`)
- 󰙱 C (`.c`, `.h`)
- 󰙲 C++ (`.cpp`, `.hpp`, `.cc`, `.cxx`)
- 󰌛 C# (`.cs`)
- 󰌟 PHP (`.php`)
- 󰴭 Ruby (`.rb`, `gemfile`)
- 󰛥 Swift (`.swift`)
- 󰢱 Lua (`.lua`)
-  Vim (`.vim`)

### Web Technologies
- 󰌝 HTML (`.html`, `.htm`)
- 󰌜 CSS (`.css`, `.less`)
- 󰟬 SCSS/SASS (`.scss`, `.sass`)
- 󰡄 Vue/Svelte (`.vue`, `.svelte`)
- 󱓞 Astro (`.astro`)

### Configuration & Data
- 󰘦 JSON (`.json`, `.jsonc`, `.json5`)
- 󰈙 YAML/TOML (`.yml`, `.yaml`, `.toml`)
- 󰗀 XML (`.xml`)
- 󰈙 INI (`.ini`)

### Documentation
- 󰍔 Markdown (`.md`, `.mdx`, `README.md`)
- 󰈦 PDF (`.pdf`)
- 󰈬 Word (`.doc`, `.docx`)

### Shell Scripts
- 󰆍 Shell (`.sh`, `.bash`, `.zsh`)
- 󰈺 Fish (`.fish`)
- 󰨊 PowerShell (`.ps1`)

### Media Files
- 󰈟 Images (`.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`)
- 󰜡 SVG (`.svg`)
- 󰕧 Video (`.mp4`, `.mkv`, `.avi`, `.mov`)
- 󰎆 Audio (`.mp3`, `.wav`, `.flac`)

### Archives
- 󰗄 Archives (`.zip`, `.rar`, `.7z`, `.tar`, `.gz`)

### Special Files
- 󰎙 Node packages (`package.json`, `package-lock.json`)
- 󰊢 Git files (`.gitignore`, `.gitconfig`)
- 󰡨 Docker (`Dockerfile`, `docker-compose.yml`)
- 󰙪 Environment (`.env`, `.env.local`)
- 󰱺 ESLint (`.eslintrc`)
- 󰬗 Prettier (`.prettierrc`)
- 󰿃 License (`LICENSE`, `license`)
- 󱁤 Makefile (`Makefile`, `makefile`)

### Special Directories
-  GitHub (`.github`)
-  Node modules (`node_modules`)
-  Git (`.git`)
- 󰙨 Tests (`test`, `tests`, `__tests__`)
- 󰈙 Docs (`docs`)
- 󰏗 Build output (`build`, `dist`)
-  Config (`config`, `.config`)
- 󰉏 Assets (`assets`, `images`, `img`)
- 󰡀 Components (`components`)
- 󰫮 Libraries (`lib`)
- 󰘧 Utils (`utils`)
- 󰥨 Scripts (`scripts`)

## Usage

Open lf in any directory:
```bash
lf
```

The icons will automatically match what you see in Neovim's file explorer (`:NvimTreeToggle`).

## Keybindings in lf

- `h` - Go up directory
- `l` - Open file/directory
- `j/k` - Navigate down/up
- `q` - Quit
- `e` - Edit in nvim
- `<leader>ee` - Toggle NvimTree in Neovim

Enjoy consistent icons across both lf and Neovim! 🎉

## Colors Configuration

lf now displays files with colors matching your Neovim configuration!

### Color Examples:
- **JavaScript** files (`.js`) - Yellow (#F7DF1E)
- **TypeScript** files (`.ts`) - Blue (#3178C6)
- **Python** files (`.py`) - Blue (#3776AB)
- **React** files (`.jsx`, `.tsx`) - Cyan (#61DAFB)
- **Go** files (`.go`) - Cyan (#00ADD8)
- **Rust** files (`.rs`) - Red-Orange (#CE422B)
- **Markdown** files (`.md`) - Blue (#519ABA)
- **JSON** files (`.json`) - Yellow (#CBCB41)
- **HTML** files (`.html`) - Orange (#E34F26)
- **CSS** files (`.css`) - Blue (#1572B6)

### How Colors Work:
Colors are configured via the `LF_COLORS` environment variable in your `.zshrc`.
The colors use RGB values that exactly match your nvim-web-devicons configuration.

To see the colors in action:
```bash
cd /tmp/lf-color-test && lf
```

### Customizing Colors:
Edit `~/.config/zsh/.zshrc` and look for the `LF_COLORS` section around line 543.
Colors use the format: `*.ext=38;2;R;G;B:` where R, G, B are RGB values (0-255).

After editing, reload your shell:
```bash
source ~/.config/zsh/.zshrc
```
