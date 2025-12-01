# AeroSpace Keybindings Reference

## Windows App - Quick Jump (Like macOS Spaces)

**Note:** Windows App spans both monitors. Jump to it instantly like switching between macOS spaces.

| Keybind | Action | Description |
|---------|--------|-------------|
| `Alt+-` | Jump to Windows (Monitor 2) | Focus monitor 2 (secondary) and activate Windows App |
| `Alt+=` | Jump to Windows (Monitor 1) | Focus monitor 1 (main/MacBook) and activate Windows App |
| `Cmd+Shift+W` | Launch Windows App | Opens Windows App if not running |
| `Cmd+Shift+M` | Jump to Browsers | Switch to Workspace 1 (Browsers) |
| `Cmd+Shift+D` | Jump to Development | Switch to Workspace 2 (Development) |

---

## Workspace Navigation

| Keybind | Workspace | Apps |
|---------|-----------|------|
| `Alt+1` | Browsers | Arc, Chrome, Brave, Safari |
| `Alt+2` | Development | Wezterm, Ghostty, VS Code, Cursor, Warp |
| `Alt+3` | Communication | Discord |
| `Alt+4` | Productivity | Obsidian, Notion |
| `Alt+5` | Media | Spotify |
| `Alt+6` | Office Suite | Excel, PowerPoint, Word |
| `Alt+T` | Work Apps | Teams, Outlook, Zoom, Slack, Thinkorswim (all floating) |

---

## Move Window to Workspace

| Keybind | Action |
|---------|--------|
| `Alt+Shift+1` | Move current window to Browsers workspace |
| `Alt+Shift+2` | Move current window to Development workspace |
| `Alt+Shift+3` | Move current window to Communication workspace |
| `Alt+Shift+4` | Move current window to Productivity workspace |
| `Alt+Shift+5` | Move current window to Media workspace |
| `Alt+Shift+6` | Move current window to Office workspace |
| `Alt+Shift+T` | Move current window to Work Apps workspace |
| `Alt+Shift+W` | Move current window to Windows workspace |

---

## Quick App Launchers (Single Key)

### Browsers (Left Hand - Top Row)
| Keybind | App |
|---------|-----|
| `Alt+W` | Google Chrome |
| `Alt+E` | Brave Browser |

### Development (Left Hand - Home Row)
| Keybind | App |
|---------|-----|
| `Alt+A` | Ghostty |
| `Alt+S` | WezTerm |
| `Alt+D` | VS Code |
| `Alt+F` | Cursor |

### Communication (Left Hand - Bottom Row)
| Keybind | App |
|---------|-----|
| `Alt+Z` | Slack |
| `Alt+X` | Discord |
| `Alt+C` | WhatsApp (opens floating) |
| `Alt+V` | Zoom (opens floating) |

### Productivity & Media (Right Hand)
| Keybind | App |
|---------|-----|
| `Alt+O` | Obsidian |
| `Alt+N` | Notion |
| `Alt+M` | Microsoft Outlook |
| `Alt+P` | Spotify |

---

## Window Navigation (Vim-style)

| Keybind | Action |
|---------|--------|
| `Alt+H` | Focus window to the left |
| `Alt+J` | Focus window below |
| `Alt+K` | Focus window above |
| `Alt+L` | Focus window to the right |

---

## Window Movement

| Keybind | Action |
|---------|--------|
| `Alt+Shift+H` | Move window to the left |
| `Alt+Shift+J` | Move window down |
| `Alt+Shift+K` | Move window up |
| `Alt+Shift+L` | Move window to the right |

---

## Window Join (Split Management)

| Keybind | Action |
|---------|--------|
| `Alt+Shift+Left` | Join with left window |
| `Alt+Shift+Down` | Join with window below |
| `Alt+Shift+Up` | Join with window above |
| `Alt+Shift+Right` | Join with right window |

---

## Layout Controls

| Keybind | Action |
|---------|--------|
| `Alt+/` | Toggle layout (horizontal/vertical tiles) |
| `Alt+,` | Toggle accordion layout |
| `Alt+Ctrl+F` | Toggle floating/tiling |
| `Alt+Ctrl+Shift+F` | Fullscreen current window |

---

## Window Resizing

| Keybind | Action |
|---------|--------|
| `Alt+Shift+-` | Decrease window size |
| `Alt+Shift+=` | Increase window size |

---

## Workspace Management

| Keybind | Action |
|---------|--------|
| `Alt+Tab` | Switch back and forth between last two workspaces |
| `Alt+Shift+Tab` | Move workspace to next monitor |

---

## Special Modes

### Apps Mode (`Alt+Shift+Enter` to activate)
Access additional app launchers with single keys:

#### Development
- `W` - WezTerm
- `G` - Ghostty
- `V` - VS Code
- `C` - Cursor
- `R` - Warp

#### Browsers
- `A` - Arc
- `H` - Chrome
- `B` - Brave
- `S` - Safari

#### Communication
- `D` - Discord
- `Q` - WhatsApp

#### Productivity
- `O` - Obsidian
- `N` - Notion

#### Media
- `P` - Spotify

#### Office
- `E` - Excel
- `Shift+P` - PowerPoint
- `Shift+O` - Word

#### Work Apps (Workspace 7)
- `T` - Thinkorswim
- `Shift+T` - Microsoft Teams
- `L` - Slack
- `Z` - Zoom
- `M` - Microsoft Outlook

#### Windows
- `Shift+W` - Windows App

Press `Esc` to exit Apps Mode

---

### Service Mode (`Alt+Shift+;` to activate)

| Key | Action |
|-----|--------|
| `Esc` | Reload config and exit mode |
| `R` | Reset layout (flatten workspace tree) |
| `F` | Toggle floating/tiling |
| `Backspace` | Close all windows except current |

---

## Tmux Session Manager

| Keybind | Action |
|---------|--------|
| `Cmd+Shift+T` | Open tmux session selector (Ghostty/WezTerm) |

---

## Special Window Behaviors

### Always Floating (Maintain Custom Width)
- **WhatsApp** - Floats anywhere, not tied to workspace
- **Workspace 7 Apps** (Teams, Outlook, Zoom, Slack, Thinkorswim) - All float and maintain their own screen width
- **Finder** - System window, maintains width
- **System Settings** - System window, maintains width
- **Calculator** - System window, maintains width
- **App Store** - System window, maintains width
- **Activity Monitor** - System window, maintains width
- **Maccy** - Clipboard manager, maintains width

---

## Workspace Assignments

| Workspace | Letter/Number | Apps Assigned | Monitor (Dual Setup) | Layout |
|-----------|---------------|---------------|----------------------|--------|
| Browsers | 1 | Arc, Chrome, Brave, Safari | **Focused monitor** (moveable) | Tiling |
| Development | 2 | Wezterm, Ghostty, VS Code, Cursor, Warp | **Focused monitor** (moveable) | Tiling |
| Communication | 3 | Discord | **Focused monitor** (moveable) | Tiling |
| Productivity | 4 | Obsidian, Notion | **Focused monitor** (moveable) | Tiling |
| Media | 5 | Spotify | **Focused monitor** (moveable) | Tiling |
| Office | 6 | Excel, PowerPoint, Word | **Focused monitor** (moveable) | Tiling |
| Work Apps | 7 (T) | Teams, Outlook, Zoom, Slack, Thinkorswim | **Focused monitor** (moveable) | **Floating** (all apps maintain their width) |

**Note:** Windows App is not assigned to any workspace - it floats freely and can span both monitors.

---

## Tips

1. **Windows App Quick Jump**:
   - `Alt+-` focuses monitor 2 (secondary/external) and activates Windows App
   - `Alt+=` focuses monitor 1 (main/MacBook) and activates Windows App
   - Jump back to macOS by pressing workspace keys (`Alt+1`, `Alt+2`, etc.)
2. **Important: How macOS Fullscreen Works**:
   - When Windows App is in fullscreen, macOS creates ONE fullscreen space on ONE monitor
   - It cannot span both monitors in fullscreen mode (this is a macOS limitation)
   - **Recommended setup**: Use Windows App in **windowed mode** (not fullscreen) and maximize it manually across both monitors
   - This way Windows App spans both monitors and the jump keys work perfectly
3. **Alternative: Two Separate Connections**:
   - Create two Windows App connections (to the same PC)
   - Put each in fullscreen on different monitors
   - Use `Alt+-` for monitor 2's Windows, `Alt+=` for monitor 1's Windows
4. **Three Apps Fit**: Windows are configured with minimal gaps (4px inner, 6px outer) to fit 3 apps side-by-side
5. **Floating Apps**: WhatsApp and Zoom always float, making them accessible from any workspace
6. **System Windows**: macOS system apps (Finder, Settings, etc.) maintain their natural size
7. **How Workspaces Follow Your Focus**:
   - When you press `Alt+T` (or any workspace key), that workspace appears on **whichever monitor your cursor/focus is on**
   - Example: Cursor on monitor 1 → press `Alt+T` → workspace 7 appears on monitor 1
   - Example: Cursor on monitor 2 → press `Alt+T` → workspace 7 appears on monitor 2
8. **Moving Workspaces Between Monitors**: Press `Alt+Shift+Tab` to move the current workspace to the other monitor
9. **Workspace 7 - No Split Screen**: All apps in workspace 7 (Teams, Outlook, Zoom, Slack, Thinkorswim) are configured to **float** and maintain their own screen width. They won't be tiled or split-screen - each maintains its natural window size.
10. **Quick Access to Work Apps**: Press `Alt+T` to instantly switch to the Work Apps workspace
