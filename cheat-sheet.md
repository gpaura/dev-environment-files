# 🚀 Development Environment Cheat Sheet

A comprehensive reference for all your custom keybindings and shortcuts across tmux, Neovim, AeroSpace, and WezTerm.

---

## 🖥️ **TMUX** - Terminal Multiplexer

### Core Settings

- **Prefix Key**: `Ctrl+Q` (instead of default Ctrl+B)
- **Mouse Support**: Enabled
- **Base Index**: Windows and panes start at 1

### 🔑 **Essential Key Bindings**

#### **Session Management**

| Key | Action |
|-----|--------|
| `Ctrl+Q` + `X` | Kill current session (with confirmation) |
| `Ctrl+Q` + `F` | Choose session from list |
| `Ctrl+Q` + `Ctrl+T` | Create new "trading" session |
| `Ctrl+Q` + `Ctrl+D` | Create new "development" session |
| `Ctrl+Q` + `Ctrl+M` | Create new "monitoring" session |

#### **Window Management**

| Key | Action |
|-----|--------|
| `Ctrl+Q` + `N` | Create new window (with prompt for name) |
| `Ctrl+Q` + `R` | Rename current window |
| `Ctrl+Q` + `K` | Kill current window (with confirmation) |
| `Option+1-9` | Switch to window 1-9 |
| `Ctrl+Option+H` | Previous window |
| `Ctrl+Option+L` | Next window |
| `Ctrl+Q` + `Tab` | Last used window |
| `<` | Move window left |
| `>` | Move window right |

#### **Quick Window Creators**

| Key | Action |
|-----|--------|
| `Ctrl+Q` + `Ctrl+W` | New "workspace" window in home |
| `Ctrl+Q` + `Ctrl+F` | New "finance" window in ~/finance |
| `Ctrl+Q` + `Ctrl+N` | New "notes" window in ~/notes |
| `Ctrl+Q` + `Ctrl+S` | New "server" window |
| `Ctrl+Q` + `P` | New project window (prompts for name) |

#### **Pane Splitting & Management**

| Key | Action |
|-----|--------|
| `Ctrl+Q` + `\|` | Split horizontally (side by side) |
| `Ctrl+Q` + `-` | Split vertically (top/bottom) |
| `Ctrl+Q` + `h/j/k/l` | Navigate panes (vim-style) |
| `Option+H/J/K/L` | Navigate panes (alternative) |
| `Ctrl+H/J/K/L` | Smart pane switching (vim-aware) |

#### **Pane Resizing**

| Key | Action |
|-----|--------|
| `Ctrl+Q` + `H` | Resize pane left |
| `Ctrl+Q` + `J` | Resize pane down |
| `Ctrl+Q` + `K` | Resize pane up |
| `Ctrl+Q` + `L` | Resize pane right |

#### **Copy Mode (Vi-style)**

| Key | Action |
|-----|--------|
| `Ctrl+Q` + `[` | Enter copy mode |
| `Ctrl+Q` + `]` | Paste buffer |
| `v` | Start selection (in copy mode) |
| `y` | Copy selection to clipboard |
| `r` | Rectangle selection toggle |

#### **Layouts**

| Key | Action |
|-----|--------|
| `Option+1` | Even horizontal layout |
| `Option+2` | Even vertical layout |
| `Option+3` | Main horizontal layout |
| `Option+4` | Main vertical layout |
| `Option+5` | Tiled layout |
| `F1` | Finance layout (main vertical, 120 cols) |
| `F2` | Finance layout (main horizontal, 25 rows) |
| `F3` | Tiled layout |

#### **Killing/Closing** ⚠️

| Key | Action |
|-----|--------|
| `Ctrl+Q` + `x` | Kill current pane (with confirmation) |
| `Ctrl+Q` + `K` | Kill current window (with confirmation) |
| `Ctrl+Q` + `X` | Kill current session (with confirmation) |
| `exit` or `Ctrl+D` | Exit current pane/shell (graceful) |

**Alternative Commands:**

- `:kill-pane` - Kill current pane without confirmation
- `:kill-window` - Kill current window without confirmation
- `:kill-session` - Kill current session without confirmation
- `:kill-session -t session_name` - Kill specific session by name
- `:kill-server` - Kill entire tmux server (all sessions)

#### **Utilities**

| Key | Action |
|-----|--------|
| `Ctrl+Q` + `r` | Reload tmux config |
| `Ctrl+Q` + `q` | Display pane numbers |
| `Ctrl+Q` + `m` | Highlight active pane briefly |
| `Ctrl+Q` + `I` | Show session info |
| `Ctrl+Q` + `W` | List windows with paths |

---

## 🎯 **NEOVIM** - Text Editor

### Leader Key

- **Leader**: `Space`

### 🔑 **Core Key Bindings**

#### **Mode Switching**

| Key | Action |
|-----|--------|
| `jk` | Exit insert mode (from insert mode) |

#### **Search & Navigation**

| Key | Action |
|-----|--------|
| `<leader>nh` | Clear search highlights |

#### **Number Operations**

| Key | Action |
|-----|--------|
| `<leader>+` | Increment number under cursor |
| `<leader>-` | Decrement number under cursor |

#### **Window Management 2**

| Key | Action |
|-----|--------|
| `<leader>sv` | Split window vertically |
| `<leader>sh` | Split window horizontally |
| `<leader>se` | Make splits equal size |
| `<leader>sx` | Close current split |

#### **Tab Management**

| Key | Action |
|-----|--------|
| `<leader>to` | Open new tab |
| `<leader>tx` | Close current tab |
| `<leader>tn` | Go to next tab |
| `<leader>tp` | Go to previous tab |
| `<leader>tf` | Open current buffer in new tab |
| `<leader>tc` | Smart tab close (quit if last tab) |

#### **Formatting**

| Key | Action |
|-----|--------|
| `<leader>f` | Format entire file (LSP) |

---

## 🪟 **AEROSPACE** - Window Manager

### Core Concepts

- **Workspaces**: 5 themed workspaces
- **Focus**: Vim-style navigation (hjkl)
- **Layout**: Tiling with automatic app assignment

### 🔑 **Key Bindings**

#### **Focus & Navigation**

| Key | Action |
|-----|--------|
| `Option+H` | Focus left window |
| `Option+J` | Focus down window |
| `Option+K` | Focus up window |
| `Option+L` | Focus right window |

#### **Moving Windows**

| Key | Action |
|-----|--------|
| `Option+Shift+H` | Move window left |
| `Option+Shift+J` | Move window down |
| `Option+Shift+K` | Move window up |
| `Option+Shift+L` | Move window right |

#### **Workspace Navigation**

| Key | Action |
|-----|--------|
| `Option+1` | Switch to workspace 1 (Browsers) |
| `Option+2` | Switch to workspace 2 (Development) |
| `Option+3` | Switch to workspace 3 (Communication) |
| `Option+4` | Switch to workspace 4 (Productivity) |
| `Option+5` | Switch to workspace 5 (Media) |
| `Option+Tab` | Back and forth between workspaces |

#### **Moving Windows to Workspaces**

| Key | Action |
|-----|--------|
| `Option+Shift+1` | Move window to workspace 1 |
| `Option+Shift+2` | Move window to workspace 2 |
| `Option+Shift+3` | Move window to workspace 3 |
| `Option+Shift+4` | Move window to workspace 4 |
| `Option+Shift+5` | Move window to workspace 5 |

#### **Layout Management**

| Key | Action |
|-----|--------|
| `Option+/` | Toggle tiles horizontal/vertical |
| `Option+,` | Toggle accordion horizontal/vertical |
| `Option+Ctrl+F` | Toggle floating/tiling |
| `Option+Ctrl+Shift+F` | Toggle fullscreen |

#### **Window Joining**

| Key | Action |
|-----|--------|
| `Option+Shift+Left` | Join with left window |
| `Option+Shift+Down` | Join with down window |
| `Option+Shift+Up` | Join with up window |
| `Option+Shift+Right` | Join with right window |

#### **Resizing**

| Key | Action |
|-----|--------|
| `Option+Shift+-` | Resize smart (smaller) |
| `Option+Shift+=` | Resize smart (larger) |

#### **Quick App Launchers**

| Key | Action |
|-----|--------|
| `Option+A` | Open Arc browser |
| `Option+W` | Open WezTerm |
| `Option+G` | Open Ghostty |
| `Option+O` | Open Obsidian |
| `Option+S` | Open Spotify |
| `Option+D` | Open Discord |
| `Option+Z` | Open Zoom |
| `Option+N` | Open Notion |
| `Option+C` | Open Google Chrome |
| `Option+V` | Open VS Code |

#### **Service Mode** (`Option+Shift+;`)

| Key | Action |
|-----|--------|
| `Esc` | Reload config and exit service mode |
| `R` | Reset layout (flatten workspace tree) |
| `F` | Toggle floating/tiling layout |
| `Backspace` | Close all windows but current |

#### **Apps Mode** (`Option+Shift+Enter`)

| Key | Action |
|-----|--------|
| `W` | WezTerm |
| `G` | Ghostty |
| `V` | VS Code |
| `C` | Cursor |
| `A` | Arc |
| `H` | Chrome |
| `B` | Brave |
| `D` | Discord |
| `T` | Teams |
| `Z` | Zoom |
| `Option+W` | WhatsApp |
| `O` | Obsidian |
| `N` | Notion |
| `M` | Outlook |
| `S` | Spotify |
| `R` | Remote Desktop |

### 📁 **Workspace Organization**

| Workspace | Apps | Purpose |
|-----------|------|---------|
| **1** | Arc, Chrome, Brave | Web browsing |
| **2** | WezTerm, Ghostty, VS Code, Cursor | Development |
| **3** | Slack, Discord, WhatsApp, Teams, Zoom | Communication |
| **4** | Obsidian, Notion, Outlook | Productivity |
| **5** | Spotify | Media & Entertainment |

---

## 💻 **WEZTERM** - Terminal Emulator

### Core Features

- **macOS-style shortcuts** for familiar feel
- **Multi-theme support** including LGBT rainbow themes
- **Advanced pane management** for VS Code-like layouts
- **Smart window positioning** and always-on-top options

### 🔑 **Essential Key Bindings**

#### **Text Editing (macOS Style)**

| Key | Action |
|-----|--------|
| `Cmd+A` | Select all |
| `Cmd+C` | Copy |
| `Cmd+V` | Paste |
| `Cmd+X` | Cut (select all + copy + clear) |
| `Cmd+Z` | Undo |
| `Cmd+Y` | Redo |

#### **Cursor Movement (macOS Style)**

| Key | Action |
|-----|--------|
| `Cmd+Left` | Beginning of line |
| `Cmd+Right` | End of line |
| `Cmd+E` | End of line (alternative) |
| `Option+Left` | Previous word |
| `Option+Right` | Next word |

#### **Text Selection**

| Key | Action |
|-----|--------|
| `Cmd+Shift+Left` | Select to beginning of line |
| `Cmd+Shift+Right` | Select to end of line |
| `Option+Shift+Left` | Select previous word |
| `Option+Shift+Right` | Select next word |
| `Shift+Left/Right` | Select character by character |

#### **Tab Management**

| Key | Action |
|-----|--------|
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab |
| `Cmd+N` | New window |
| `Cmd+Tab` | Next tab |
| `Cmd+Shift+Tab` | Previous tab |
| `Cmd+5-9` | Switch to tab 5-9 |

#### **🌈 Theme Switching**

| Key | Action |
|-----|--------|
| `Cmd+Shift+1` | LGBT Dark Rainbow Theme |
| `Cmd+Shift+2` | LGBT Light Rainbow Theme |
| `Cmd+Shift+3` | Original Dark Theme |
| `Cmd+Shift+4` | Original Light Theme |

#### **Pane Management (VS Code Style)**

| Key | Action |
|-----|--------|
| `Cmd+D` | Split horizontally (side by side) |
| `Cmd+Shift+D` | Split vertically (top/bottom) |
| `Cmd+Shift+W` | Close current pane |
| `Cmd+Option+←/→/↑/↓` | Navigate between panes |
| `Cmd+Shift+Z` | Toggle pane zoom |

#### **🏗️ VS Code-Like Layout Automation**

| Key | Action |
|-----|--------|
| `Cmd+Shift+L` | Launch VS Code-like WezTerm layout |
| `Cmd+Shift+T` | Launch tmux VS Code-like layout |

> **Note**: These create a 3-pane setup similar to VS Code:
> - **Left**: File explorer/navigation
> - **Center**: Main editor
> - **Bottom**: Terminal/console

#### **Font & Display**

| Key | Action |
|-----|--------|
| `Cmd++` | Increase font size |
| `Cmd+-` | Decrease font size |
| `Cmd+0` | Reset font size |
| `Cmd+Shift+T` | Toggle always on top |

#### **Search & Navigation**

| Key | Action |
|-----|--------|
| `Cmd+F` | Search (with current selection) |
| `Cmd+[` | Enter copy mode |
| `Cmd+PageUp/PageDown` | Scroll through history |

#### **System Integration**

| Key | Action |
|-----|--------|
| `Cmd+Q` | Quit application |
| `Cmd+R` | Reload configuration |
| `Cmd+M` | Minimize window |
| `Cmd+H` | Hide window |
| `Cmd+,` | Open config in Neovim |

#### **Text Deletion (macOS Style)**

| Key | Action |
|-----|--------|
| `Cmd+Backspace` | Delete to beginning of line |
| `Cmd+Delete` | Delete to beginning of line |
| `Cmd+K` | Delete to end of line |
| `Option+Backspace` | Delete previous word |

#### **Special Features**

| Key | Action |
|-----|--------|
| `Shift+Enter` | Insert newline (like in Claude) |
| `Cmd+Click` | Open link under cursor |
| **Triple-click** | Select entire line |

---

## 🎨 **Advanced Features**

### **WezTerm Theme System**

- **4 Built-in Themes**: Dark, Light, LGBT Dark Rainbow, LGBT Light Rainbow
- **Dynamic Status Bar**: Shows current theme with appropriate colors
- **Theme Persistence**: Settings saved to `~/.config/wezterm/theme`
- **Rainbow Cycling**: LGBT themes cycle through pride colors every 10 seconds

### **Tmux Integration**

- **Vim-aware Navigation**: Seamlessly switch between tmux panes and vim splits
- **Smart Copy Mode**: Vi-style navigation with macOS clipboard integration
- **Finance Layouts**: Specialized layouts for trading/monitoring workflows
- **Session Templates**: Quick creation of themed sessions

### **AeroSpace Workspace Philosophy**

- **Themed Workspaces**: Each workspace dedicated to specific app categories
- **Auto-assignment**: Apps automatically move to their designated workspace
- **Floating Exceptions**: System apps (Finder, Preferences) remain floating
- **Multi-monitor Ready**: Configuration supports both single and dual monitor setups

### **Productivity Shortcuts Summary**

#### **Quick Development Setup**

1. `Option+2` - Switch to Development workspace
2. `Cmd+Shift+L` - Launch VS Code-like layout in WezTerm
3. `Option+V` - Open VS Code for heavy editing

#### **Communication Flow**

1. `Option+3` - Switch to Communication workspace
2. `Option+D` - Open Discord
3. `Option+Z` - Join Zoom meeting

#### **Note-taking Session**

1. `Option+4` - Switch to Productivity workspace
2. `Option+O` - Open Obsidian
3. `Option+N` - Open Notion for collaboration

---

## 📝 **Configuration Files**

| Tool | Config Location |
|------|----------------|
| **Tmux** | `~/.config/tmux/tmux.conf` |
| **Neovim** | `~/.config/nvim/init.lua` |
| **AeroSpace** | `~/.config/aerospace/aerospace.toml` |
| **WezTerm** | `~/.config/wezterm/wezterm.lua` |

---

## 🔄 **Reloading Configurations**

| Tool | Reload Command |
|------|---------------|
| **Tmux** | `Ctrl+Q` + `r` |
| **Neovim** | `:source %` or restart |
| **AeroSpace** | `Option+Shift+;` → `Esc` |
| **WezTerm** | `Cmd+R` |

---

*This cheat sheet covers all the custom keybindings and shortcuts configured in your development environment. Keep it handy for quick reference! 🚀*