# AeroSpace Keybindings Reference

## Workspace Navigation & Launchers

Aerospace is configured with "Smart Launchers". Switching to a workspace will automatically check if the primary app for that workspace is running, and launch it if it's not.

| Keybind | Workspace | Name | Primary Apps Launched/Focused |
|---------|-----------|------|-------------------------------|
| `Alt+1` | 1 | Main | (Generic / Monitor Management) |
| `Alt+2` | 2 | Browsers | Google Chrome, ChatGPT Atlas |
| `Alt+3` | 3 | Productivity | Notion |
| `Alt+4` | 4 | Communication | Slack, Microsoft Teams |
| `Alt+5` | 5 | Trading | Thinkorswim (Un-hides Java process) |
| `Alt+Q` | 6 | Apple/System | Finder, System Settings |
| `Alt+W` | 7 | Terminals | WezTerm (Ghostty/Warp also routed here) |
| `Alt+E` | 8 | Development | Cursor (VS Code also routed here) |
| `Alt+R` | 9 | Social | WhatsApp (Monitor 1) |
| `Alt+T` | 10 | Windows (Main) | Windows App (Monitor 1) |
| `Alt+M` | 11 | Mail | Microsoft Outlook |
| `Alt+Y` | 12 | Background | (Secondary Monitor Background) |
| `Alt+\`` | 13 | Windows (Sec) | Windows App (Monitor 2) |

---

## App & Layout Rules

Some applications are forced to specific workspaces or layouts (Floating vs Tiling).

| Workspace | Assigned Apps | Layout Behavior |
|-----------|---------------|-----------------|
| **2 (Browsers)** | Chrome, Safari, Brave, Arc, Firefox, Atlas | Tiling |
| **3 (Productivity)** | Notion, Obsidian | Tiling |
| | Excel, Word, PowerPoint, Numbers, GDocs | **Floating** |
| **4 (Comm)** | Slack, Teams, Zoom | **Floating** |
| **5 (Trading)** | Thinkorswim, Java Apps | **Floating** |
| **6 (System)** | Finder, Settings, Activity Monitor, Calculator, App Store | **Floating** |
| **7 (Terminals)** | Ghostty, Warp, WezTerm, iTerm2 | Tiling |
| **8 (Dev)** | VS Code, Cursor | Tiling |
| **9 (Social)** | WhatsApp, Discord, Messages | **Floating** |
| **10 (Media)** | Spotify, Windows App | **Floating** |
| **11 (Mail)** | Mail, Outlook | Tiling |
| **(Utility)** | Maccy, Camera, QuickTime | **Floating** |

---

## Standard Controls

| Keybind | Action |
|---------|--------|
| `Alt+Tab` | Switch to previous workspace (back-and-forth) |
| `Alt+Shift+Tab` | Move current workspace to next monitor (wrap-around) |
| `Alt+/` | Toggle layout (Horizontal / Vertical) |
| `Alt+,` | Toggle layout (Accordion) |
| `Alt+Ctrl+F` | Toggle Floating / Tiling for current window |
| `Alt+Ctrl+Shift+F` | Toggle Fullscreen |
| `Cmd+Shift+J` | **Tmux Session Manager** (Launches via Ghostty/WezTerm) |

### Vim-Style Navigation
*   **Focus**: `Alt + h/j/k/l` (Left, Down, Up, Right)
*   **Move Window**: `Alt + Shift + h/j/k/l`
*   **Join Windows**: `Alt + Shift + Arrows`
*   **Resize**: `Alt + Shift + -/=`

---

## Special Modes

### 1. Apps Mode (`Alt+Shift+Enter`)
A dedicated mode for launching specific applications without switching workspaces explicitly.

*   **Browsers**: `A` (Arc), `H` (Chrome), `B` (Brave), `S` (Safari)
*   **Dev**: `V` (VS Code), `C` (Cursor)
*   **Terminals**: `W` (WezTerm), `G` (Ghostty), `R` (Warp)
*   **Comm**: `D` (Discord), `Q` (WhatsApp), `L` (Slack), `Shift+T` (Teams), `Z` (Zoom)
*   **Productivity**: `O` (Obsidian), `N` (Notion)
*   **Office**: `E` (Excel), `Shift+O` (Word), `Shift+P` (PowerPoint), `M` (Outlook)
*   **Trading**: `T` (Thinkorswim - with visibility fix)
*   **Media**: `P` (Spotify)
*   **Windows**: `Shift+W` (Windows App)

Press `Esc` to return to Main mode.

### 2. Service Mode (`Alt+Shift+;`)
Maintenance and layout reset tools.

*   `R`: **Reset Layout** (Flatten workspace tree) - Fixes broken layouts.
*   `F`: Toggle Floating/Tiling
*   `Backspace`: Close all windows *except* current
*   `Esc`: Reload Config & Exit