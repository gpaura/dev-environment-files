# lf File Manager Cheat Sheet

## Navigation

| Key | Action |
|-----|--------|
| `h` | Go to parent directory (up) |
| `l` | Open file/directory (down) |
| `j` | Move down |
| `k` | Move up |
| `gg` | Go to top |
| `G` | Go to bottom |
| `Ctrl+u` | Half page up |
| `Ctrl+d` | Half page down |

## File Operations

| Key | Action |
|-----|--------|
| `y` | Yank/copy file |
| `Y` | Copy full file path to clipboard |
| `p` | Paste |
| `c` | Cut |
| `d` | Delete |
| `r` | Rename |
| `m` | Make directory |
| `t` | Touch (create file) |
| `x` | Extract archive |

## Selection & Marking

| Key | Action |
|-----|--------|
| `Space` | Mark/save selection |
| `Tab` | Toggle selection |
| `Esc` | Clear selection |

## Quick Navigation Shortcuts

| Key | Action |
|-----|--------|
| `gd` | Go to ~/dev |
| `gc` | Go to ~/.config |
| `gh` | Go to home (~) |
| `gt` | Go to /tmp |
| `gw` | Go to ~/workspace |

## File Management

| Key | Action |
|-----|--------|
| `Enter` | Open file/directory |
| `nf` | Create new file (prompts for name) |
| `nd` | Create new directory (prompts for name) |
| `nr` | Rename (prompts for new name) |

## External Tools

| Key | Action |
|-----|--------|
| `e` | Edit with nvim |
| `E` | Open with VS Code |
| `o` | Open with default application |
| `i` | Show file info |

## Git Integration

| Key | Action |
|-----|--------|
| `gs` | Git status |
| `gl` | Git log (last 10 commits) |
| `gd` | Git diff |

## Search

| Key | Action |
|-----|--------|
| `f` | Find forward |
| `F` | Find backward |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |

## Bookmarks

| Key | Action |
|-----|--------|
| `b` | Load bookmark |
| `B` | Save bookmark |

---

# lsd Command Cheat Sheet

## Basic Usage

```bash
lsd                    # List files with icons and colors
lsd -l                 # Long format
lsd -la                # Long format with hidden files
lsd -1                 # One file per line
```

## Display Options

```bash
lsd --tree             # Tree view
lsd --tree --depth 2   # Tree view with depth limit
lsd -F                 # Append indicator (/, @, etc.)
lsd --icon always      # Always show icons
lsd --color always     # Always show colors
```

## Sorting

```bash
lsd --sort size        # Sort by size
lsd --sort time        # Sort by modification time
lsd --sort extension   # Sort by extension
lsd --reverse          # Reverse sort order
```

## Filtering

```bash
lsd -d */              # List directories only
lsd *.js               # List only .js files
lsd --ignore-glob "*.log"  # Ignore .log files
```

## Information Display

```bash
lsd -l                 # Show permissions, size, date
lsd --size short       # Short size format
lsd --date relative    # Relative dates (e.g., "2 hours ago")
lsd --blocks permission,size,date,name  # Custom columns
```

## Common Combinations

```bash
lsd -la --tree --depth 2           # Tree with hidden files, 2 levels
lsd -l --sort size --reverse       # Largest files first
lsd --icon always --color always   # Full icons and colors (used by lf)
```

## Color Customization

lsd uses `LS_COLORS` environment variable for colors:
- Configured in `~/.config/zsh/.zshrc`
- Directories: Yellow (#FFD866)
- Files: Colored by extension (matching nvim-web-devicons)

## Configuration Files

- **lf config**: `~/.config/lf/lfrc`
- **lf icons**: `~/.config/lf/icons`
- **lf colors**: `~/.config/lf/colors`
- **lsd config**: `~/.config/lsd/config.yaml`
- **LS_COLORS**: `~/.config/zsh/.zshrc`

---

## Tips & Tricks

### lf Tips
1. **Preview files**: The preview pane shows file contents for text files
2. **Bulk operations**: Use `Space` to mark multiple files, then operate on them
3. **Custom commands**: Add custom commands in `lfrc` with `cmd` keyword
4. **Shell commands**: Press `:` to enter command mode and run shell commands

### lsd Tips
1. **Alias in shell**: `alias ls='lsd'` to replace ls
2. **Tree alternative**: `lsd --tree` is a colorful alternative to `tree`
3. **Git integration**: lsd shows git status indicators
4. **Nerd fonts required**: Make sure you have a Nerd Font installed for icons

---

## Color Scheme

Both lf and lsd are configured to match nvim-tree Monokai Pro Octagon palette:

- **Folders**: Yellow (#FFD866 / 38;5;221)
- **JavaScript/TypeScript**: Yellow/Cyan
- **Python**: Blue
- **Markdown**: Blue
- **JSON/YAML**: Yellow/Red
- **Archives**: Yellow
- **Images**: Purple
- **Videos**: Orange
- **Audio**: Cyan

---

## Troubleshooting

### Icons not showing in lf
- Make sure `set icons true` is in `~/.config/lf/lfrc`
- Check that `~/.config/lf/icons` file exists

### Colors not working
- Run `source ~/.config/zsh/.zshrc` to reload LS_COLORS
- Check that LS_COLORS is exported in your shell

### lsd not found
- Install with: `brew install lsd`
- Verify installation: `which lsd`
