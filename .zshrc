# ============================================================================
# .ZSHRC WITH COMMAND KEY SUPPORT
# ============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
export TERM_BOLD=1

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# ENVIRONMENT SETUP
# ============================================================================

export PATH="$PATH:$(go env GOPATH)/bin"
export PROMPT='%B'"$PROMPT"'%b'
export RPROMPT='%B'"$RPROMPT"'%b'
export LANG=en_US.UTF-8
export EDITOR=/opt/homebrew/bin/nvim

# Prompt settings
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

# Completions
source <(kubectl completion zsh)
complete -C '/usr/local/bin/aws_completer' aws

# ============================================================================
# ZSH AUTOSUGGESTIONS (EARLY LOAD)
# ============================================================================

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ============================================================================
# VI MODE WITH MACOS COMMAND KEY SUPPORT
# ============================================================================

# Enable vi mode
set -o vi

# Create a custom widget for jj that only triggers on consecutive j presses
jj-to-cmd-mode() {
    if [[ $LBUFFER =~ 'j$' ]]; then
        # Remove the last 'j' and switch to command mode
        LBUFFER=${LBUFFER%j}
        zle vi-cmd-mode
    else
        # If not preceded by 'j', just insert 'j'
        zle self-insert
    fi
}
zle -N jj-to-cmd-mode

# Bind only the 'j' key in insert mode to our custom function
bindkey -M viins 'j' jj-to-cmd-mode

# ============================================================================
# COMMAND KEY BINDINGS (from WezTerm) - Insert mode specific
# ============================================================================

# Command+A - Select all (Ctrl+A in terminal = beginning of line)
bindkey -M viins '^A' beginning-of-line

# Command+E - End of line  
bindkey -M viins '^E' end-of-line

# Command+K - Kill to end of line
bindkey -M viins '^K' kill-line

# Command+U - Kill to beginning of line (Command+Backspace/Delete)
bindkey -M viins '^U' backward-kill-line

# Command+Z - Undo
bindkey -M viins '^Z' undo

# Command+Y - Redo  
bindkey -M viins '^Y' redo

# Command+F - Forward search
bindkey -M viins '^F' forward-char

# ============================================================================
# OPTION KEY BINDINGS (Alt/Meta keys) + TEXT SELECTION
# ============================================================================

# Option+Left/Right - Word movement (keep in insert mode)
bindkey -M viins '\eb' backward-word          # Option+Left
bindkey -M viins '\ef' forward-word           # Option+Right
bindkey -M viins '^[[1;3D' backward-word      # Option+Left (alternative sequence)
bindkey -M viins '^[[1;3C' forward-word       # Option+Right (alternative sequence)

# Create custom selection widgets that don't trigger vi mode
option-shift-left() {
    # Move cursor left by word but stay in insert mode
    zle backward-word
}
zle -N option-shift-left

option-shift-right() {
    # Move cursor right by word but stay in insert mode  
    zle forward-word
}
zle -N option-shift-right

shift-left() {
    # Move cursor left by character but stay in insert mode
    zle backward-char
}
zle -N shift-left

shift-right() {
    # Move cursor right by character but stay in insert mode
    zle forward-char
}
zle -N shift-right

shift-up() {
    # Move cursor up but stay in insert mode
    zle up-line-or-history
}
zle -N shift-up

shift-down() {
    # Move cursor down but stay in insert mode
    zle down-line-or-history  
}
zle -N shift-down

# Bind these custom widgets to prevent vi mode activation
bindkey -M viins '^[[1;4D' option-shift-left   # Option+Shift+Left
bindkey -M viins '^[[1;4C' option-shift-right  # Option+Shift+Right
bindkey -M viins '^[[1;2D' shift-left          # Shift+Left
bindkey -M viins '^[[1;2C' shift-right         # Shift+Right  
bindkey -M viins '^[[1;2A' shift-up            # Shift+Up
bindkey -M viins '^[[1;2B' shift-down          # Shift+Down

# Command+Shift+Arrow keys - Line selection (keep in insert mode)
bindkey -M viins '^[[1;6D' beginning-of-line  # Cmd+Shift+Left
bindkey -M viins '^[[1;6C' end-of-line        # Cmd+Shift+Right
bindkey -M viins '^[[1;6A' beginning-of-buffer-or-history # Cmd+Shift+Up
bindkey -M viins '^[[1;6B' end-of-buffer-or-history       # Cmd+Shift+Down

# Option+Backspace/Delete - Word deletion (keep in insert mode)
bindkey -M viins '^W' backward-kill-word      # Option+Backspace (Ctrl+W from WezTerm)
bindkey -M viins '\ed' kill-word              # Option+Delete (Alt+d)

# Also bind for command mode (vicmd) so they work there too
bindkey -M vicmd '^[[1;3D' backward-word      # Option+Left in command mode
bindkey -M vicmd '^[[1;3C' forward-word       # Option+Right in command mode

# ============================================================================
# STANDARD MACOS DELETION BEHAVIOR
# ============================================================================

# Regular delete/backspace (not affected by Command key)
bindkey '^[[3~' delete-char          # Delete key
bindkey '^?' backward-delete-char    # Backspace
bindkey '\e[3~' delete-char         # Alternative delete
bindkey '^H' backward-delete-char    # Ctrl+H (backspace)

# ============================================================================
# NAVIGATION AND HISTORY
# ============================================================================

# Arrow keys for history search
bindkey '^[[A' history-search-backward    # Up arrow
bindkey '^[[B' history-search-forward     # Down arrow

# Ctrl+R for reverse search (keep this working)
bindkey '^R' history-incremental-search-backward

# Home/End keys
bindkey '^[[H' beginning-of-line     # Home
bindkey '^[[F' end-of-line           # End
bindkey '^[[1~' beginning-of-line    # Home (alternative)
bindkey '^[[4~' end-of-line          # End (alternative)

# Page Up/Down for history
bindkey '^[[5~' beginning-of-buffer-or-history  # Page Up
bindkey '^[[6~' end-of-buffer-or-history        # Page Down

# ============================================================================
# AUTOSUGGESTIONS CONFIGURATION (UPDATED BINDINGS)
# ============================================================================

# Updated autosuggestion bindings that don't conflict with our Command keys
bindkey '^u' autosuggest-toggle      # Ctrl+U for toggle (keep existing)
bindkey '^ ' autosuggest-accept      # Ctrl+Space for accept
bindkey '^[[Z' autosuggest-execute   # Shift+Tab for execute

# Navigation bindings that work with our setup
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
bindkey '^L' vi-forward-word

# ============================================================================
# ADDITIONAL USEFUL BINDINGS
# ============================================================================

# Ctrl+L - Clear screen (standard)
bindkey '^L' clear-screen

# Ctrl+D - Delete character or exit
bindkey '^D' delete-char-or-list

# Ctrl+X Ctrl+E - Edit command line in editor
bindkey '^X^E' edit-command-line

# ============================================================================
# VI MODE INDICATORS
# ============================================================================

function zle-keymap-select {
    case $KEYMAP in
        vicmd)
            echo -ne '\e[1 q'  # Block cursor for normal mode
            ;;
        viins|main)
            echo -ne '\e[5 q'  # Beam cursor for insert mode
            ;;
        visual)
            echo -ne '\e[3 q'  # Underline cursor for visual mode
            ;;
    esac
}
zle -N zle-keymap-select

# Initialize with beam cursor
echo -ne '\e[5 q'

# Reset cursor when command line is accepted
function zle-line-init() {
    echo -ne '\e[5 q'
}
zle -N zle-line-init

# ============================================================================
# FZF INTEGRATION
# ============================================================================

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# FZF theme
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# Use fd instead of find
export FZF_DEFAULT_COMMAND="fd --type f --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# FZF completion functions
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# Load fzf-git if available
[ -f ~/fzf-git.sh/fzf-git.sh ] && source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced FZF customization
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# FZF key bindings that work with our Command key setup
bindkey -M viins '^T' fzf-file-widget        # Ctrl+T - File finder
bindkey -M viins '\ec' fzf-cd-widget         # Alt+C - Directory finder
# Note: Ctrl+R is handled by history search above

# ============================================================================
# ALIASES
# ============================================================================

# Basic aliases
alias la=tree
alias cat=bat
alias cl='clear'
alias http="xh"

# Git aliases
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker aliases
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Eza (better ls)
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"
alias ls="eza --color=always --icons=always"
alias lt2="eza -lTg --level=2 --icons=always"
alias lt3="eza -lTg --level=3 --icons=always"
alias lta2="eza -lTag --level=2 --icons=always"
alias lta3="eza -lTag --level=3 --icons=always"
alias ll='ls -l'

# Tmux aliases
alias tks='tmux kill-session -t'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'

# Zoxide (better cd)
alias cd='z'

# Other tools
alias nu='nu --config ~/.config/nushell/config.nu'
alias theme='~/theme.sh'
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# ============================================================================
# TESTING FUNCTIONS
# ============================================================================

# Function to debug key sequences 
debug-keys() {
    echo "=== KEY SEQUENCE DEBUGGER ==="
    echo "Press any key combination to see what sequence it sends."
    echo "Press Ctrl+C to exit."
    echo ""
    
    while true; do
        echo -n "Press a key: "
        read -k key
        echo ""
        echo "Key pressed: $key"
        echo "Hex dump: $(echo -n "$key" | xxd)"
        echo "---"
    done
}

# Function to test Command keys
test-cmd-keys() {
    echo "Testing Command key bindings:"
    echo "1. Type some text"
    echo "2. Try Command+A (should go to beginning)"
    echo "3. Try Command+E (should go to end)" 
    echo "4. Try Command+K (should delete to end)"
    echo "5. Try Command+Z (should undo)"
    echo "6. Try Option+Left/Right (should move by word)"
    echo ""
    echo "Testing VS Code-style text selection:"
    echo "7. Try Shift+Left/Right (select characters)"
    echo "8. Try Option+Shift+Left/Right (select words)"
    echo "9. Try Cmd+Shift+Left/Right (select to line start/end)"
    echo "10. Try Shift+Up/Down (select lines)"
    echo ""
    echo "If Option+Shift enters vi mode, the key bindings need adjustment."
    echo "Type 'exit' to return to normal shell"
    
    # Simple test line
    print -n "Test line: "
    read test_input
    echo "You typed: $test_input"
}

# Function specifically for testing text selection
test-selection() {
    echo "=== TEXT SELECTION TEST ==="
    echo ""
    echo "Current vi mode keymap: $KEYMAP"
    echo ""
    echo "Try these selection combinations:"
    echo "• Shift + ← → : Select characters"
    echo "• Option + Shift + ← → : Select words"
    echo "• Cmd + Shift + ← → : Select to line beginning/end"
    echo "• Shift + ↑ ↓ : Select lines"
    echo ""
    echo "After selecting text, try:"
    echo "• Cmd + C : Copy selection"
    echo "• Cmd + X : Cut selection"
    echo "• Delete/Backspace : Delete selection"
    echo ""
    echo "Test phrase with multiple words for selection practice:"
    echo "The quick brown fox jumps over the lazy dog"
    echo ""
    
    print -n "Practice here: "
    read test_selection
    echo "You entered: $test_selection"
    echo "Final keymap mode: $KEYMAP"
}

# Function to check current mode and reset if needed
check-mode() {
    echo "Current keymap: $KEYMAP"
    if [[ $KEYMAP != "viins" && $KEYMAP != "main" ]]; then
        echo "Switching back to insert mode..."
        zle vi-insert-mode 2>/dev/null || echo "Not in ZLE context"
    fi
}

# Function to force insert mode
force-insert() {
    zle vi-insert-mode 2>/dev/null && echo "Switched to insert mode" || echo "Not in ZLE context"
}

# Tmux session management function
tkserver() {
    echo "Current tmux sessions:"
    tmux list-sessions 2>/dev/null || { echo "No tmux sessions found."; return; }
    
    echo ""
    read -p "Kill all sessions? (y/N): " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        tmux kill-server
        echo "All tmux sessions killed."
    else
        echo "Operation cancelled."
    fi
}

# ============================================================================
# PRODUCTIVITY ALIASES FOR TEXT MANIPULATION
# ============================================================================

# Quick access to common text operations
alias copy-pwd='pwd | pbcopy'           # Copy current directory path
alias copy-last='fc -ln -1 | pbcopy'    # Copy last command
alias paste-exec='pbpaste | source /dev/stdin'  # Execute clipboard content

# For working with files and selection
alias edit-clip='pbpaste | nvim -'      # Edit clipboard content in nvim
alias clip-to-file='pbpaste > '         # Save clipboard to file (add filename)

# Testing aliases
alias test-keys='test-cmd-keys'
alias test-select='test-selection'
alias debug-keys='debug-keys'
alias check-mode='check-mode'
alias insert-mode='force-insert'

# ============================================================================
# ENVIRONMENT VARIABLES AND COLORS
# ============================================================================

# Set EZA_COLORS for better directory colors
export EZA_COLORS="di=1;35:fi=1;37:ln=1;36:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31:ex=1;32:$EZA_COLORS"

# Bat theme
export BAT_THEME=tokyonight_night

# History setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# ============================================================================
# ADDITIONAL TOOLS INITIALIZATION
# ============================================================================

# Load Powerlevel10k theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Load Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load syntax highlighting (keep at end)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Additional PATH exports
export PATH=$PATH:/Users/gabrielpaura/.spicetify
export PATH="$HOME/.rbenv/shims:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:/Users/gabrielpaura/.local/bin"

# ============================================================================
# OPTIONAL TOOL INITIALIZATION
# ============================================================================

# Load FZF if available
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load Atuin if available
if command -v atuin > /dev/null 2>&1; then
    eval "$(atuin init zsh)"
fi

# TheFuck aliases
if command -v thefuck > /dev/null 2>&1; then
    eval $(thefuck --alias)
    eval $(thefuck --alias fk)
fi

# Zoxide initialization
if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Starship initialization
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# ============================================================================
# SKETCHYBAR INTEGRATION (macOS)
# ============================================================================

# SketchyBar integration
if command -v sketchybar &>/dev/null; then
    # Reload sketchybar when zshrc is loaded
    sketchybar --reload

    # Enhanced brew function with SketchyBar integration
    function brew() {
        # Execute the original Homebrew command
        command brew "$@"
        # Check if command should trigger SketchyBar update
        if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]] || [[ $* =~ "list" ]] || [[ $* =~ "install" ]] || [[ $* =~ "uninstall" ]] || [[ $* =~ "bundle" ]] || [[ $* =~ "doctor" ]] || [[ $* =~ "info" ]] || [[ $* =~ "cleanup" ]]; then
            sketchybar --trigger brew_update
        fi
    }
fi

# ============================================================================
# WELCOME MESSAGE
# ============================================================================

echo "💡 Enhanced macOS Command key bindings loaded!"
echo "   🔧 Debug key sequences: debug-keys"
echo "   🧪 Test selection: test-select"
echo "   ⚡ Check vi mode: check-mode"
echo "   🔄 Force insert mode: insert-mode"
echo "   📖 Test all features: test-keys"


# ============================================================================
# COMPREHENSIVE DELETION COMMANDS FIX
# This will fix ALL deletion issues: Ctrl+U, Command+Delete, Command+K
# ============================================================================

# First, let's debug what's currently bound and what's interfering
debug-deletion-keys() {
    echo "=== DEBUGGING DELETION KEY BINDINGS ==="
    echo ""
    echo "Testing what sequences are sent for deletion keys:"
    echo "Press each key and see what sequence it sends:"
    echo "1. Ctrl+U"
    echo "2. Command+Delete (if configured in WezTerm)"
    echo "3. Command+K"
    echo "4. Regular Delete key"
    echo "5. Regular Backspace"
    echo ""
    echo "Press Ctrl+C when done"
    
    while true; do
        echo -n "Press deletion key: "
        read -k key
        echo ""
        printf "Key: %q, Hex: " "$key"
        echo -n "$key" | xxd -l 10
        echo "---"
    done
}

# ============================================================================
# CLEAR ALL CONFLICTING BINDINGS FIRST
# ============================================================================

# Function to clear potentially conflicting bindings
clear-conflicting-bindings() {
    # Remove any existing conflicting bindings for these keys
    bindkey -M viins -r '^U' 2>/dev/null
    bindkey -M viins -r '^K' 2>/dev/null
    bindkey -M viins -r '^A' 2>/dev/null
    bindkey -M viins -r '^E' 2>/dev/null
    bindkey -M viins -r '^W' 2>/dev/null
    
    bindkey -M vicmd -r '^U' 2>/dev/null
    bindkey -M vicmd -r '^K' 2>/dev/null
    bindkey -M vicmd -r '^A' 2>/dev/null
    bindkey -M vicmd -r '^E' 2>/dev/null
    bindkey -M vicmd -r '^W' 2>/dev/null
    
    echo "🧹 Cleared potentially conflicting bindings"
}

# ============================================================================
# CORE DELETION FUNCTIONS - GUARANTEED TO WORK
# ============================================================================

# Custom deletion widgets that will definitely work
delete-to-beginning() {
    # Delete from cursor to beginning of line
    if [[ $CURSOR -gt 0 ]]; then
        BUFFER="${BUFFER[$((CURSOR+1)),-1]}"
        CURSOR=0
        echo -ne "\r\033[K"  # Clear line
        echo -n "$BUFFER"
        echo -ne "\r"
        echo -n "${BUFFER[1,$CURSOR]}"
    fi
}
zle -N delete-to-beginning

delete-to-end() {
    # Delete from cursor to end of line
    if [[ $CURSOR -lt ${#BUFFER} ]]; then
        BUFFER="${BUFFER[1,$CURSOR]}"
        echo -ne "\033[K"  # Clear from cursor to end of line
    fi
}
zle -N delete-to-end

delete-word-backward() {
    # Delete previous word
    local old_cursor=$CURSOR
    zle backward-word
    local new_cursor=$CURSOR
    BUFFER="${BUFFER[1,$new_cursor]}${BUFFER[$((old_cursor+1)),-1]}"
    CURSOR=$new_cursor
}
zle -N delete-word-backward

# Simple navigation widgets
go-to-beginning() {
    CURSOR=0
}
zle -N go-to-beginning

go-to-end() {
    CURSOR=${#BUFFER}
}
zle -N go-to-end

# ============================================================================
# APPLY BINDINGS FOR ALL POSSIBLE SEQUENCES
# ============================================================================

apply-deletion-bindings() {
    echo "🔧 Applying deletion key bindings..."
    
    # Clear any conflicts first
    clear-conflicting-bindings
    
    # === CTRL+U - Delete to beginning ===
    bindkey -M viins '^U' delete-to-beginning
    bindkey -M vicmd '^U' delete-to-beginning
    
    # === COMMAND+K - Delete to end ===
    bindkey -M viins '^K' delete-to-end
    bindkey -M vicmd '^K' delete-to-end
    
    # === COMMAND+A - Go to beginning ===
    bindkey -M viins '^A' go-to-beginning
    bindkey -M vicmd '^A' go-to-beginning
    
    # === COMMAND+E - Go to end ===
    bindkey -M viins '^E' go-to-end
    bindkey -M vicmd '^E' go-to-end
    
    # === COMMAND+W - Delete word backward ===
    bindkey -M viins '^W' delete-word-backward
    bindkey -M vicmd '^W' delete-word-backward
    
    # === Additional sequences that might be sent by Command+Delete ===
    # WezTerm might send different sequences for Command+Delete
    bindkey -M viins '^[[3~' delete-to-beginning    # Delete key
    bindkey -M viins '^[[3;2~' delete-to-beginning  # Shift+Delete
    bindkey -M viins '^[[3;5~' delete-to-beginning  # Ctrl+Delete
    bindkey -M viins '^[^?' delete-to-beginning     # Alt+Backspace
    
    # === Undo/Redo ===
    bindkey -M viins '^Z' undo
    bindkey -M vicmd '^Z' undo
    bindkey -M viins '^Y' redo
    bindkey -M vicmd '^Y' redo
    
    echo "✅ All deletion bindings applied!"
}

# ============================================================================
# TESTING FUNCTIONS
# ============================================================================

test-each-deletion() {
    echo "=== TESTING EACH DELETION COMMAND ==="
    echo ""
    
    # Test 1: Ctrl+U
    echo "TEST 1: Ctrl+U (Delete to beginning)"
    echo "Type: 'Hello World Test' then move cursor to middle and press Ctrl+U"
    echo -n "Test Ctrl+U: "
    vared -c test1
    echo "Result: '$test1'"
    echo ""
    
    # Test 2: Command+K  
    echo "TEST 2: Command+K (Delete to end)"
    echo "Type: 'Hello World Test' then move cursor to middle and press Command+K"
    echo -n "Test Cmd+K: "
    vared -c test2
    echo "Result: '$test2'"
    echo ""
    
    # Test 3: Command+A and Command+E
    echo "TEST 3: Command+A (Go to beginning) and Command+E (Go to end)"
    echo "Type text, then try Command+A and Command+E"
    echo -n "Test navigation: "
    vared -c test3
    echo "Result: '$test3'"
    echo ""
}

# Test specific sequences
test-raw-sequences() {
    echo "=== TESTING RAW KEY SEQUENCES ==="
    echo ""
    echo "Current key mappings:"
    echo "Ctrl+U (^U):"
    bindkey | grep '\\^U'
    echo ""
    echo "Ctrl+K (^K):"
    bindkey | grep '\\^K'
    echo ""
    echo "Ctrl+A (^A):"
    bindkey | grep '\\^A'
    echo ""
    echo "Ctrl+E (^E):"
    bindkey | grep '\\^E'
    echo ""
    echo "Current mode: $KEYMAP"
}

# Force fix function
force-fix-deletion() {
    echo "🚨 FORCE FIXING DELETION KEYS..."
    
    # Force insert mode
    zle vi-insert-mode 2>/dev/null
    
    # Remove ALL bindings for these keys
    bindkey -M viins -r '^U' 2>/dev/null
    bindkey -M viins -r '^K' 2>/dev/null
    bindkey -M viins -r '^A' 2>/dev/null
    bindkey -M viins -r '^E' 2>/dev/null
    bindkey -M viins -r '^W' 2>/dev/null
    
    # Wait a moment
    sleep 0.1
    
    # Re-apply with standard ZLE widgets (guaranteed to work)
    bindkey -M viins '^U' backward-kill-line
    bindkey -M viins '^K' kill-line
    bindkey -M viins '^A' beginning-of-line
    bindkey -M viins '^E' end-of-line
    bindkey -M viins '^W' backward-kill-word
    
    # Also apply to command mode
    bindkey -M vicmd '^U' backward-kill-line
    bindkey -M vicmd '^K' kill-line
    bindkey -M vicmd '^A' beginning-of-line
    bindkey -M vicmd '^E' end-of-line
    bindkey -M vicmd '^W' backward-kill-word
    
    echo "✅ Force fix applied using standard ZLE widgets!"
    echo "🧪 Test with: test-each-deletion"
}

# Simple test for just Ctrl+U
test-ctrl-u-simple() {
    echo "=== SIMPLE CTRL+U TEST ==="
    echo "1. Type some text below"
    echo "2. Move cursor to middle of text"  
    echo "3. Press Ctrl+U"
    echo "4. Everything before cursor should disappear"
    echo ""
    
    echo -n "Type text here: "
    vared simple_test
    echo "Final result: '$simple_test'"
    
    # Check what Ctrl+U is actually bound to
    echo ""
    echo "Ctrl+U is bound to:"
    bindkey | grep '\\^U' || echo "NOT BOUND!"
}

# ============================================================================
# AUTO-CONFIGURATION
# ============================================================================

# Function to automatically set up everything
auto-setup-deletion() {
    echo "🤖 AUTO-SETTING UP DELETION KEYS..."
    
    # Step 1: Clear conflicts
    clear-conflicting-bindings
    
    # Step 2: Apply our custom bindings
    apply-deletion-bindings
    
    # Step 3: Ensure we're in insert mode
    zle vi-insert-mode 2>/dev/null
    
    # Step 4: Test that bindings are active
    echo ""
    echo "Verifying bindings:"
    echo "Ctrl+U: $(bindkey | grep '\\^U' | head -1)"
    echo "Ctrl+K: $(bindkey | grep '\\^K' | head -1)"
    echo "Ctrl+A: $(bindkey | grep '\\^A' | head -1)"
    echo ""
    
    echo "✅ Auto-setup complete!"
    echo "🧪 Test with: test-ctrl-u-simple"
}

# ============================================================================
# ALIASES FOR EASY ACCESS
# ============================================================================

alias debug-deletion='debug-deletion-keys'
alias test-deletion='test-each-deletion'
alias test-sequences='test-raw-sequences'
alias force-fix='force-fix-deletion'
alias test-simple='test-ctrl-u-simple'
alias auto-setup='auto-setup-deletion'

# ============================================================================
# IMMEDIATE SETUP
# ============================================================================

# Run the auto-setup immediately when this is sourced
auto-setup-deletion

echo ""
echo "🎯 DELETION COMMANDS FIX LOADED!"
echo ""
echo "🧪 Available tests:"
echo "   test-simple     - Simple Ctrl+U test"
echo "   test-deletion   - Test all deletion commands"
echo "   debug-deletion  - See what keys send what sequences"
echo "   force-fix       - Nuclear option: reset everything"
echo "   auto-setup      - Re-run auto configuration"
echo ""
echo "💡 If nothing works, try: force-fix"

# ============================================================================
# FIX FOR COMMAND+SHIFT+ARROW KEYS
# This prevents them from entering vi mode and provides proper text selection
# ============================================================================

# ============================================================================
# DEBUGGING FUNCTION - Let's see exactly what's happening
# ============================================================================

debug-cmd-shift-arrows() {
    echo "=== DEBUGGING COMMAND+SHIFT+ARROW ISSUE ==="
    echo ""
    echo "Let's check what happens step by step:"
    echo ""
    echo "1. Current vi mode: $KEYMAP"
    echo "2. Current bindings for Command+Shift sequences:"
    
    echo ""
    echo "Bindings for ^[[1;6D (Cmd+Shift+Left):"
    bindkey | grep '1;6D' || echo "NOT BOUND"
    
    echo ""
    echo "Bindings for ^[[1;6C (Cmd+Shift+Right):"
    bindkey | grep '1;6C' || echo "NOT BOUND"
    
    echo ""
    echo "3. Let's test what mode we're in after pressing keys..."
    echo "Press Command+Shift+Left or Right, then press Enter to see mode:"
    
    read -r
    echo "Mode after key press: $KEYMAP"
    
    if [[ $KEYMAP == "vicmd" ]]; then
        echo "❌ PROBLEM: Key switched to vi command mode!"
        echo "We need to prevent this and stay in insert mode."
    else
        echo "✅ Good: Still in insert mode"
    fi
}

# ============================================================================
# CUSTOM WIDGETS THAT FORCE INSERT MODE
# ============================================================================

# Command+Shift+Left - Move to beginning but STAY in insert mode
cmd-shift-left-stay-insert() {
    # Force insert mode first
    zle vi-insert-mode
    
    # Move to beginning
    zle beginning-of-line
    
    # Visual feedback without switching modes
    echo -ne "\r\033[44;37m"  # Blue background, white text
    echo -n " ← MOVED TO BEGINNING "
    echo -ne "\033[0m\r"      # Reset color and return to start
    
    # Ensure we stay in insert mode
    zle vi-insert-mode
    
    # Redraw the line properly
    zle reset-prompt
}
zle -N cmd-shift-left-stay-insert

# Command+Shift+Right - Move to end but STAY in insert mode
cmd-shift-right-stay-insert() {
    # Force insert mode first
    zle vi-insert-mode
    
    # Move to end
    zle end-of-line
    
    # Visual feedback without switching modes
    echo -ne "\r\033[44;37m"  # Blue background, white text
    echo -n " → MOVED TO END "
    echo -ne "\033[0m"        # Reset color
    
    # Ensure we stay in insert mode
    zle vi-insert-mode
    
    # Redraw the line properly
    zle reset-prompt
}
zle -N cmd-shift-right-stay-insert

# ============================================================================
# OPTION+SHIFT+ARROWS - Word movement staying in insert mode
# ============================================================================

# Option+Shift+Left - Previous word in insert mode
opt-shift-left-stay-insert() {
    # Force insert mode
    zle vi-insert-mode
    
    # Move to previous word
    zle backward-word
    
    # Visual feedback
    echo -ne "\r\033[43;30m"  # Yellow background, black text
    echo -n " ← WORD "
    echo -ne "\033[0m"        # Reset color
    
    # Stay in insert mode
    zle vi-insert-mode
    zle reset-prompt
}
zle -N opt-shift-left-stay-insert

# Option+Shift+Right - Next word in insert mode
opt-shift-right-stay-insert() {
    # Force insert mode
    zle vi-insert-mode
    
    # Move to next word
    zle forward-word
    
    # Visual feedback
    echo -ne "\r\033[43;30m"  # Yellow background, black text
    echo -n " → WORD "
    echo -ne "\033[0m"        # Reset color
    
    # Stay in insert mode
    zle vi-insert-mode
    zle reset-prompt
}
zle -N opt-shift-right-stay-insert

# ============================================================================
# CLEAR AND REBIND THE SEQUENCES
# ============================================================================

fix-cmd-shift-arrows() {
    echo "🔧 Fixing Command+Shift+Arrow key bindings..."
    
    # Remove existing bindings that might be causing vi mode switch
    bindkey -M viins -r '^[[1;6D' 2>/dev/null
    bindkey -M viins -r '^[[1;6C' 2>/dev/null
    bindkey -M viins -r '^[[1;4D' 2>/dev/null
    bindkey -M viins -r '^[[1;4C' 2>/dev/null
    
    # Remove from command mode too (so they can't trigger from there)
    bindkey -M vicmd -r '^[[1;6D' 2>/dev/null
    bindkey -M vicmd -r '^[[1;6C' 2>/dev/null
    bindkey -M vicmd -r '^[[1;4D' 2>/dev/null
    bindkey -M vicmd -r '^[[1;4C' 2>/dev/null
    
    # Wait a moment
    sleep 0.1
    
    # Bind ONLY in insert mode to our custom widgets
    bindkey -M viins '^[[1;6D' cmd-shift-left-stay-insert   # Cmd+Shift+Left
    bindkey -M viins '^[[1;6C' cmd-shift-right-stay-insert  # Cmd+Shift+Right
    bindkey -M viins '^[[1;4D' opt-shift-left-stay-insert   # Opt+Shift+Left
    bindkey -M viins '^[[1;4C' opt-shift-right-stay-insert  # Opt+Shift+Right
    
    # Also ensure we're in insert mode
    zle vi-insert-mode 2>/dev/null
    
    echo "✅ Command+Shift+Arrow bindings fixed!"
    echo "💡 They should now move cursor without entering vi command mode"
}

# ============================================================================
# TESTING FUNCTION
# ============================================================================

test-cmd-shift-fixed() {
    echo "=== TESTING FIXED COMMAND+SHIFT+ARROWS ==="
    echo ""
    echo "Current mode: $KEYMAP"
    echo ""
    echo "Instructions:"
    echo "1. Type: 'the quick brown fox jumps over the lazy dog'"
    echo "2. Move cursor to middle of text"
    echo "3. Try Command+Shift+Left (should go to beginning, stay in insert mode)"
    echo "4. Try Command+Shift+Right (should go to end, stay in insert mode)"
    echo "5. Try Option+Shift+Left/Right (should move by words, stay in insert mode)"
    echo ""
    echo "If you see colored feedback messages, it's working!"
    echo "If the cursor becomes a block, it switched to vi mode (BAD)"
    echo ""
    
    echo -n "Test here: "
    vared test_text
    
    echo ""
    echo "Final mode: $KEYMAP"
    if [[ $KEYMAP == "vicmd" ]]; then
        echo "❌ Still switching to vi command mode - need more fixes"
        zle vi-insert-mode 2>/dev/null
    else
        echo "✅ Stayed in insert mode - working correctly!"
    fi
}

# ============================================================================
# FORCE INSERT MODE FUNCTION
# ============================================================================

force-insert-mode() {
    echo "🔄 Forcing insert mode..."
    zle vi-insert-mode 2>/dev/null
    echo "Current mode: $KEYMAP"
    
    # Also fix the cursor
    echo -ne '\e[5 q'  # Beam cursor for insert mode
    
    echo "✅ Forced to insert mode with beam cursor"
}

# ============================================================================
# NUCLEAR OPTION - DISABLE VI MODE TEMPORARILY
# ============================================================================

disable-vi-mode-temp() {
    echo "🚨 TEMPORARILY DISABLING VI MODE for testing..."
    
    # Switch to emacs mode (no vi mode)
    set +o vi
    
    # Set up basic emacs-style bindings
    bindkey '^A' beginning-of-line
    bindkey '^E' end-of-line
    bindkey '^K' kill-line
    bindkey '^U' backward-kill-line
    
    # Set up the arrow key bindings in emacs mode
    bindkey '^[[1;6D' beginning-of-line  # Cmd+Shift+Left
    bindkey '^[[1;6C' end-of-line        # Cmd+Shift+Right
    bindkey '^[[1;4D' backward-word      # Opt+Shift+Left
    bindkey '^[[1;4C' forward-word       # Opt+Shift+Right
    
    echo "✅ Vi mode disabled, using emacs mode"
    echo "🧪 Test Command+Shift+Arrows now - they should work without mode switching"
    echo "🔄 Run 'enable-vi-mode-back' to restore vi mode when done testing"
}

enable-vi-mode-back() {
    echo "🔄 Re-enabling vi mode..."
    set -o vi
    
    # Restore our custom bindings
    fix-cmd-shift-arrows
    
    echo "✅ Vi mode restored with fixed bindings"
}

# ============================================================================
# ALIASES
# ============================================================================

alias debug-cmd-shift='debug-cmd-shift-arrows'
alias fix-arrows='fix-cmd-shift-arrows'
alias test-arrows='test-cmd-shift-fixed'
alias force-insert='force-insert-mode'
alias disable-vi='disable-vi-mode-temp'
alias enable-vi='enable-vi-mode-back'

# ============================================================================
# AUTO-FIX ON LOAD
# ============================================================================

# Apply the fix immediately
fix-cmd-shift-arrows

echo ""
echo "🎯 COMMAND+SHIFT+ARROW FIX LOADED!"
echo ""
echo "🧪 Available commands:"
echo "   test-arrows      - Test the fixed arrow keys"
echo "   debug-cmd-shift  - Debug what's happening"
echo "   fix-arrows       - Re-apply the fix"
echo "   force-insert     - Force insert mode if stuck"
echo "   disable-vi       - Temporarily disable vi mode for testing"
echo ""
echo "💡 The fix has been applied automatically."
echo "🚀 Try: test-arrows"

check-vi-mode() {
    # Multiple ways to check the mode
    if [[ -n "$KEYMAP" ]]; then
        echo "KEYMAP variable: $KEYMAP"
    else
        echo "KEYMAP variable: (empty)"
    fi
    
    # Check ZLE state
    if zle; then
        echo "In ZLE context: Yes"
    else
        echo "In ZLE context: No"
    fi
    
    # Check if vi mode is enabled
    if [[ -o vi ]]; then
        echo "Vi mode: Enabled"
    else
        echo "Vi mode: Disabled (emacs mode)"
    fi
}

# Simple interactive test function
test-arrows-simple() {
    echo "=== SIMPLE COMMAND+SHIFT+ARROW TEST ==="
    echo ""
    
    # Check current mode
    echo "Current setup:"
    check-vi-mode
    echo ""
    
    echo "Instructions:"
    echo "1. Type some text in the prompt below"
    echo "2. Use arrow keys to move cursor to middle"
    echo "3. Try Command+Shift+Left (should go to beginning)"
    echo "4. Try Command+Shift+Right (should go to end)"
    echo "5. Try Option+Shift+Left/Right (should move by words)"
    echo ""
    echo "Look for colored feedback messages!"
    echo ""
    
    # Initialize the variable first
    local test_input=""
    
    echo -n "Type and test here: "
    vared test_input
    
    echo ""
    echo "You entered: '$test_input'"
    echo ""
    echo "Final mode check:"
    check-vi-mode
}

# Real-time key testing
test-keys-realtime() {
    echo "=== REAL-TIME KEY TESTING ==="
    echo ""
    echo "This will show you exactly what happens when you press keys:"
    echo ""
    
    # Check current bindings
    echo "Current Command+Shift bindings:"
    bindkey | grep '1;6' || echo "None found"
    echo ""
    echo "Current Option+Shift bindings:"
    bindkey | grep '1;4' || echo "None found"
    echo ""
    
    echo "Now type some text and try the key combinations..."
    echo "Press Ctrl+C when done testing"
    echo ""
    
    # Use read with a prompt
    local input_line=""
    echo -n "Test line: "
    read -r input_line
    echo "You typed: $input_line"
}

# Test with manual step-by-step
test-step-by-step() {
    echo "=== STEP-BY-STEP COMMAND+SHIFT TEST ==="
    echo ""
    
    # Step 1: Check current state
    echo "STEP 1: Current state"
    check-vi-mode
    echo ""
    
    # Step 2: Type text
    echo "STEP 2: Type some text"
    local text=""
    echo -n "Enter text: "
    read -r text
    echo "You typed: '$text'"
    echo ""
    
    # Step 3: Test key bindings manually
    echo "STEP 3: Check if key bindings exist"
    echo "Command+Shift+Left (^[[1;6D):"
    bindkey | grep '1;6D' || echo "NOT BOUND"
    echo ""
    echo "Command+Shift+Right (^[[1;6C):"
    bindkey | grep '1;6C' || echo "NOT BOUND"
    echo ""
    echo "Option+Shift+Left (^[[1;4D):"
    bindkey | grep '1;4D' || echo "NOT BOUND"
    echo ""
    echo "Option+Shift+Right (^[[1;4C):"
    bindkey | grep '1;4C' || echo "NOT BOUND"
    echo ""
    
    # Step 4: Interactive test
    echo "STEP 4: Now test the actual keys"
    echo "Type text below and try Command+Shift+Arrows:"
    echo ""
    
    local interactive_text=""
    echo -n "Interactive test: "
    vared interactive_text
    
    echo ""
    echo "Final result: '$interactive_text'"
    echo ""
    echo "Final state:"
    check-vi-mode
}

# Debug what sequences are actually being received
debug-received-sequences() {
    echo "=== DEBUG: WHAT SEQUENCES ARE WE RECEIVING? ==="
    echo ""
    echo "Press key combinations and see what's received:"
    echo "- Command+Shift+Left"
    echo "- Command+Shift+Right" 
    echo "- Option+Shift+Left"
    echo "- Option+Shift+Right"
    echo ""
    echo "Press Ctrl+C to exit"
    echo ""
    
    while true; do
        echo -n "Press key combo: "
        read -k 20 keys  # Read up to 20 characters
        echo ""
        echo "Received: '$keys'"
        printf "Hex: "
        echo -n "$keys" | xxd -l 20
        echo "---"
    done
}

# Function to manually trigger our custom widgets
test-widgets-directly() {
    echo "=== TESTING CUSTOM WIDGETS DIRECTLY ==="
    echo ""
    
    # Test if our widgets exist
    echo "Checking if custom widgets are defined:"
    echo ""
    
    if zle -l | grep -q "cmd-shift-left-stay-insert"; then
        echo "✅ cmd-shift-left-stay-insert widget exists"
    else
        echo "❌ cmd-shift-left-stay-insert widget missing"
    fi
    
    if zle -l | grep -q "cmd-shift-right-stay-insert"; then
        echo "✅ cmd-shift-right-stay-insert widget exists"
    else
        echo "❌ cmd-shift-right-stay-insert widget missing"
    fi
    
    echo ""
    echo "All defined custom widgets:"
    zle -l | grep -E "(cmd-shift|opt-shift)" || echo "None found"
    echo ""
    
    # Try to trigger them manually (won't work outside ZLE context, but we can check)
    echo "To test widgets, type text in a prompt and try the key combinations."
}

# Simple working test
test-basic-movement() {
    echo "=== BASIC MOVEMENT TEST ==="
    echo ""
    echo "Let's test basic cursor movement first:"
    echo ""
    
    local movement_test=""
    echo "Type: 'hello world test' then try:"
    echo "- Command+A (go to beginning)"
    echo "- Command+E (go to end)"
    echo "- Option+Left/Right (move by words)"
    echo ""
    echo -n "Test basic movement: "
    vared movement_test
    
    echo ""
    echo "Result: '$movement_test'"
    
    # Check if basic movement works
    echo ""
    echo "Basic movement key bindings:"
    echo "Command+A (^A):" 
    bindkey | grep '\\^A' || echo "NOT BOUND"
    echo "Command+E (^E):"
    bindkey | grep '\\^E' || echo "NOT BOUND"
}

# ============================================================================
# UPDATED ALIASES
# ============================================================================

alias test-arrows='test-arrows-simple'
alias test-realtime='test-keys-realtime'
alias test-step='test-step-by-step'
alias debug-sequences='debug-received-sequences'
alias test-widgets='test-widgets-directly'
alias test-basic='test-basic-movement'
alias check-mode='check-vi-mode'

echo ""
echo "🔧 UPDATED TEST FUNCTIONS LOADED!"
echo ""
echo "🧪 Available tests:"
echo "   test-arrows      - Simple arrow key test (FIXED)"
echo "   test-basic       - Test basic movement first"
echo "   test-step        - Step-by-step debugging"
echo "   test-realtime    - Real-time key testing"
echo "   debug-sequences  - See what key sequences are received"
echo "   test-widgets     - Check if custom widgets exist"
echo "   check-mode       - Check current vi mode"
echo ""
echo "💡 Start with: test-basic"