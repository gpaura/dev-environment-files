# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal macOS dotfiles repository containing configuration files for various development tools and system applications. The configurations are optimized for a developer workflow using terminal applications, window management, and text editing tools.

## Repository Structure

- **nvim/**: Neovim configuration with performance-optimized Lua setup using lazy.nvim plugin manager
- **zsh/**: Z shell configuration with Powerlevel10k theme and enhanced terminal features
- **aerospace/**: AeroSpace tiling window manager configuration with workspace-based app organization
- **starship/**: Cross-shell prompt configuration using Catppuccin Mocha color scheme
- **ghostty/**: Ghostty terminal emulator configuration
- **sketchybar/**: macOS menu bar replacement configuration
- **scripts/**: Utility scripts including theme management
- **gcloud/**, **atuin/**, **tmux/**, **wezterm/**: Additional tool configurations

## Key Configuration Files

### Neovim (nvim/)

- `init.lua`: Main configuration entry point with performance optimizations
- Uses lazy.nvim for plugin management
- Includes CSV file handling, colorizer integration, and startup time monitoring
- Configuration follows modular structure with `gabriel.core` and `gabriel.lazy` modules

### Shell Configuration (zsh/)

- `.zshrc`: Main shell configuration with PATH setup, completions, and tool integrations
- Integrates with Powerlevel10k theme and various development tools
- Includes kubectl, AWS CLI completions

### Window Management (aerospace/)

- `aerospace.toml`: AeroSpace tiling window manager configuration
- Defines workspace assignments for different app categories:
  - Workspace 1: Browsers (Chrome, Arc, Brave)
  - Workspace 2: Development (terminals, VS Code, Cursor)
  - Workspace 3: Communication (Slack, Discord, Teams)
  - Workspace 4: Productivity (Obsidian, Notion, Outlook)
  - Workspace 5: Media (Spotify)

### Prompt Configuration (starship/)

- `starship.toml`: Minimal prompt with directory and git information
- Uses Catppuccin Mocha color palette
- Includes AWS, Go, and Kubernetes context display

## Development Tools

### Formatting and Linting

- Neovim includes conform.nvim for code formatting
- StyLua configuration for Lua code formatting (`nvim/.stylua.toml`)

### Plugin Management

- Neovim uses lazy.nvim with lock file (`nvim/lazy-lock.json`)
- Extensive plugin ecosystem for development, including LSP, completion, and debugging tools

## Utility Scripts

- `scripts/theme.sh`: Theme management script for system-wide appearance changes

## Common Workflows

When working with this dotfiles repository:

1. Neovim configurations should maintain the performance-optimized approach
2. Any new tool integrations should follow the existing modular structure
3. Workspace assignments in AeroSpace should align with the defined categories
4. Color schemes should maintain consistency with the Catppuccin Mocha theme
5. Shell configurations should preserve the enhanced terminal experience setup

## File Management

Most configurations use absolute paths or proper environment variable references. When modifying configurations, maintain this pattern for cross-system compatibility.
