#!/bin/zsh
# ============================================================================
# .ZSHRC WITH COMMAND KEY SUPPORT AND ENHANCED WORD SELECTION
# ============================================================================

# ============================================================================
# PATH SETUP (Must be first)
# ============================================================================

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export PATH="$PATH:/Users/gabrielpaura/.spicetify"
export PATH="$PATH:/Users/gabrielpaura/.local/bin"

# Enable Powerlevel10k instant prompt
export TERM_BOLD=1

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# ENVIRONMENT SETUP
# ============================================================================

if command -v go > /dev/null 2>&1; then
    export PATH="$PATH:$(go env GOPATH)/bin"
fi
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
if command -v kubectl > /dev/null 2>&1; then
    source <(kubectl completion zsh)
fi
complete -C '/usr/local/bin/aws_completer' aws

# ============================================================================
# ZSH AUTOSUGGESTIONS (EARLY LOAD)
# ============================================================================

if [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ============================================================================
# VI MODE WITH MACOS COMMAND KEY SUPPORT
# ============================================================================

# Enable vi mode
set -o vi

# Create a custom widget for jj that only triggers on consecutive j presses
jj-to-cmd-mode() {
    if [[ $LBUFFER =~ 'j$' ]]; then
        LBUFFER=${LBUFFER%j}
        zle vi-cmd-mode
    else
        zle self-insert
    fi
}
zle -N jj-to-cmd-mode

# Bind only the 'j' key in insert mode to our custom function
bindkey -M viins 'j' jj-to-cmd-mode

# ============================================================================
# COMMAND KEY BINDINGS
# ============================================================================

bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^Z' undo
bindkey -M viins '^Y' redo
bindkey -M viins '^F' forward-char

# ============================================================================
# OPTION KEY BINDINGS
# ============================================================================

bindkey -M viins '\eb' backward-word
bindkey -M viins '\ef' forward-word
bindkey -M viins '^[[1;3D' backward-word
bindkey -M viins '^[[1;3C' forward-word
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '\ed' kill-word

bindkey -M vicmd '^[[1;3D' backward-word
bindkey -M vicmd '^[[1;3C' forward-word

# ============================================================================
# COMMAND+DELETE/BACKSPACE BINDINGS
# ============================================================================

# Command+Delete and Command+Backspace both delete to beginning of line
# These are already handled by Command+U (^U) binding above, but adding 
# explicit bindings for the delete key sequences that WezTerm might send
bindkey -M viins '^[[3~' delete-char          # Regular Delete key
bindkey -M viins '^[[3;2~' backward-kill-line # Shift+Delete
bindkey -M viins '^[[3;5~' backward-kill-line # Ctrl+Delete (might be sent by Cmd+Delete)
bindkey -M viins '\e^?' backward-kill-word    # Alt+Backspace (Option+Backspace)

# ============================================================================
# ENHANCED WORD SELECTION WITH CONTINUOUS SELECTION
# ============================================================================

# Selection state management
typeset -g SELECTION_START=-1
typeset -g SELECTION_END=-1
typeset -g SELECTION_ACTIVE=0
typeset -g SELECTION_MODE=""

reset-selection() {
    SELECTION_START=-1
    SELECTION_END=-1
    SELECTION_ACTIVE=0
    SELECTION_MODE=""
}

show-selection() {
    local start=$1
    local end=$2
    local text="${BUFFER:$start:$((end - start))}"
    
    echo -ne "\r\033[K"
    
    if [[ $start -gt 0 ]]; then
        echo -n "${BUFFER:0:$start}"
    fi
    echo -ne "\033[7m"
    echo -n "$text"
    echo -ne "\033[0m"
    if [[ $end -lt ${#BUFFER} ]]; then
        echo -n "${BUFFER:$end}"
    fi
    
    echo -ne "\r"
    if [[ $CURSOR -gt 0 ]]; then
        echo -ne "\033[${CURSOR}C"
    fi
}

smart-word-select() {
    local direction=$1
    local orig_cursor=$CURSOR
    
    if [[ $SELECTION_ACTIVE -eq 0 ]]; then
        zle backward-word
        SELECTION_START=$CURSOR
        zle forward-word
        SELECTION_END=$CURSOR
        SELECTION_ACTIVE=1
        SELECTION_MODE="word"
        
        if [[ $direction == "left" ]]; then
            CURSOR=$SELECTION_START
        else
            CURSOR=$SELECTION_END
        fi
    else
        if [[ $direction == "left" ]]; then
            if [[ $CURSOR -eq $SELECTION_START ]]; then
                zle backward-word
                SELECTION_START=$CURSOR
            elif [[ $CURSOR -eq $SELECTION_END ]]; then
                zle backward-word
                if [[ $CURSOR -le $SELECTION_START ]]; then
                    SELECTION_END=$SELECTION_START
                    SELECTION_START=$CURSOR
                else
                    SELECTION_END=$CURSOR
                fi
            fi
        else
            if [[ $CURSOR -eq $SELECTION_END ]]; then
                zle forward-word
                SELECTION_END=$CURSOR
            elif [[ $CURSOR -eq $SELECTION_START ]]; then
                zle forward-word
                if [[ $CURSOR -ge $SELECTION_END ]]; then
                    SELECTION_START=$SELECTION_END
                    SELECTION_END=$CURSOR
                else
                    SELECTION_START=$CURSOR
                fi
            fi
        fi
    fi
    
    local selected_text="${BUFFER:$SELECTION_START:$((SELECTION_END - SELECTION_START))}"
    echo -n "$selected_text" | pbcopy
    
    show-selection $SELECTION_START $SELECTION_END
    
    echo -ne "\r\033[K\033[46;30m"
    if [[ $direction == "left" ]]; then
        echo -n " ← WORD: '$selected_text' "
    else
        echo -n " → WORD: '$selected_text' "
    fi
    echo -ne "\033[0m"
    sleep 0.5
    
    show-selection $SELECTION_START $SELECTION_END
}

smart-word-select-left() {
    smart-word-select "left"
}
zle -N smart-word-select-left

smart-word-select-right() {
    smart-word-select "right"
}
zle -N smart-word-select-right

# Reset selection on movement
for widget in backward-char forward-char up-line-or-history down-line-or-history \
              beginning-of-line end-of-line backward-word forward-word; do
    eval "
    ${widget}-and-reset() {
        reset-selection
        zle $widget
        zle reset-prompt
    }
    zle -N ${widget}-and-reset"
done

# Option+Shift+Left/Right - Word selection
bindkey -M viins '^[[1;4D' smart-word-select-left
bindkey -M viins '^[[1;4C' smart-word-select-right
bindkey -M viins '\e[1;10D' smart-word-select-left
bindkey -M viins '\e[1;10C' smart-word-select-right

# ============================================================================
# COMMAND+SHIFT SELECTION
# ============================================================================

simple-select-left() {
    if [[ $CURSOR -gt 0 ]]; then
        local before_cursor="${BUFFER:0:$CURSOR}"
        echo -n "$before_cursor" | pbcopy
        zle beginning-of-line
        echo -ne "\033[43;30m ← COPIED: '$before_cursor' \033[0m"
        sleep 1
        zle reset-prompt
    fi
}
zle -N simple-select-left

simple-select-right() {
    local buffer_length=${#BUFFER}
    if [[ $CURSOR -lt $buffer_length ]]; then
        local after_cursor="${BUFFER:$CURSOR}"
        echo -n "$after_cursor" | pbcopy
        zle end-of-line
        echo -ne "\033[43;30m → COPIED: '$after_cursor' \033[0m"
        sleep 1
        zle reset-prompt
    fi
}
zle -N simple-select-right

bindkey -M viins '^[[1;6D' simple-select-left
bindkey -M viins '^[[1;6C' simple-select-right

# ============================================================================
# SHIFT ARROW BINDINGS
# ============================================================================

shift-left() {
    zle backward-char
}
zle -N shift-left

shift-right() {
    zle forward-char
}
zle -N shift-right

shift-up() {
    zle up-line-or-history
}
zle -N shift-up

shift-down() {
    zle down-line-or-history  
}
zle -N shift-down

bindkey -M viins '^[[1;2D' shift-left
bindkey -M viins '^[[1;2C' shift-right
bindkey -M viins '^[[1;2A' shift-up
bindkey -M viins '^[[1;2B' shift-down

# ============================================================================
# STANDARD NAVIGATION
# ============================================================================

# Arrow keys with selection reset for custom selection widgets
bindkey -M viins '^[[D' backward-char-and-reset
bindkey -M viins '^[[A' history-search-backward
bindkey -M viins '^[[B' history-search-forward

# Right arrow key - default behavior (accepts autosuggestions)
# Don't bind to custom widget so autosuggestions work
bindkey -M viins '^[[C' forward-char

bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char
bindkey '\e[3~' delete-char
bindkey '^H' backward-delete-char

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history

bindkey '^R' history-incremental-search-backward

# ============================================================================
# AUTOSUGGESTIONS CONFIGURATION
# ============================================================================

# Change autosuggest-toggle to a different key to free up Ctrl+U for deletion
bindkey '^g' autosuggest-toggle  # Ctrl+G for toggle instead
bindkey '^ ' autosuggest-accept   # Ctrl+Space to accept
bindkey '^[[Z' autosuggest-execute # Shift+Tab to execute

# Right arrow accepts autosuggestion if available, otherwise moves forward
bindkey '^[[C' forward-char       # Right arrow accepts suggestions
bindkey '^[[OC' forward-char      # Right arrow (alternate sequence)

bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# ============================================================================
# ADDITIONAL BINDINGS
# ============================================================================

bindkey '^L' clear-screen
bindkey '^D' delete-char-or-list
bindkey '^X^E' edit-command-line

# ============================================================================
# VI MODE INDICATORS
# ============================================================================

function zle-keymap-select {
    case $KEYMAP in
        vicmd)
            echo -ne '\e[1 q'
            ;;
        viins|main)
            echo -ne '\e[5 q'
            ;;
        visual)
            echo -ne '\e[3 q'
            ;;
    esac
}
zle -N zle-keymap-select

echo -ne '\e[5 q'

function zle-line-init() {
    echo -ne '\e[5 q'
}
zle -N zle-line-init

# ============================================================================
# FZF INTEGRATION
# ============================================================================

if command -v fzf > /dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi

# FZF theme
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

[ -f ~/fzf-git.sh/fzf-git.sh ] && source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

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

bindkey -M viins '^T' fzf-file-widget
bindkey -M viins '\ec' fzf-cd-widget

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
alias tmux='tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'
alias tks='tmux kill-session -t'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'

# Other tools
alias nu='nu --config $XDG_CONFIG_HOME/nushell/config.nu'
alias theme='$XDG_CONFIG_HOME/scripts/theme.sh'
alias themeauto='$XDG_CONFIG_HOME/scripts/theme.sh auto'
alias reload-zsh="source $ZDOTDIR/.zshrc"
alias edit-zsh="nvim $ZDOTDIR/.zshrc"

# AeroSpace monitor configuration aliases
alias aerospace-single='$XDG_CONFIG_HOME/scripts/aerospace-monitor-switch.sh single'
alias aerospace-dual='$XDG_CONFIG_HOME/scripts/aerospace-monitor-switch.sh dual'
alias aerospace-status='$XDG_CONFIG_HOME/scripts/aerospace-monitor-switch.sh status'

# Productivity aliases
alias copy-pwd='pwd | pbcopy'
alias copy-last='fc -ln -1 | pbcopy'
alias paste-exec='pbpaste | source /dev/stdin'
alias edit-clip='pbpaste | nvim -'
alias clip-to-file='pbpaste > '

# ============================================================================
# FUNCTIONS
# ============================================================================

# Tmux session management
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
# ENVIRONMENT VARIABLES AND COLORS
# ============================================================================

export EZA_COLORS="di=1;35:fi=1;37:ln=1;36:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31:ex=1;32:$EZA_COLORS"
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

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f "$XDG_CONFIG_HOME/p10k/.p10k.zsh" ]] || source "$XDG_CONFIG_HOME/p10k/.p10k.zsh"
if [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Additional PATH exports (moved to top of file)

# ============================================================================
# OPTIONAL TOOL INITIALIZATION
# ============================================================================

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if command -v atuin > /dev/null 2>&1; then
    eval "$(atuin init zsh)"
fi

if command -v thefuck > /dev/null 2>&1; then
    eval $(thefuck --alias)
    eval $(thefuck --alias fk)
fi

if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v starship > /dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# ============================================================================
# TMUX-SPECIFIC KEY BINDINGS
# ============================================================================

# Check if we're running inside tmux
if [[ -n "$TMUX" ]]; then
    # Tmux sends different escape sequences for some keys
    
    # Command key bindings (these usually work the same)
    bindkey -M viins '^A' beginning-of-line
    bindkey -M viins '^E' end-of-line
    bindkey -M viins '^K' kill-line
    bindkey -M viins '^U' backward-kill-line
    
    # Option+Arrow keys in tmux
    bindkey -M viins '^[b' backward-word      # Option+Left
    bindkey -M viins '^[f' forward-word       # Option+Right
    bindkey -M viins '\eb' backward-word      # Alt+Left (backup)
    bindkey -M viins '\ef' forward-word       # Alt+Right (backup)
    
    # Option+Shift+Arrow keys for word selection in tmux
    bindkey -M viins '^[[1;4D' smart-word-select-left   # Option+Shift+Left
    bindkey -M viins '^[[1;4C' smart-word-select-right  # Option+Shift+Right
    
    # Some terminals send these sequences in tmux
    bindkey -M viins '^[^[[D' smart-word-select-left    # ESC+[+D
    bindkey -M viins '^[^[[C' smart-word-select-right   # ESC+[+C
    
    # Command+Shift+Arrow keys in tmux
    bindkey -M viins '^[[1;6D' simple-select-left       # Cmd+Shift+Left
    bindkey -M viins '^[[1;6C' simple-select-right      # Cmd+Shift+Right
    
    # Shift+Arrow keys in tmux
    bindkey -M viins '^[[1;2D' shift-left
    bindkey -M viins '^[[1;2C' shift-right
    bindkey -M viins '^[[1;2A' shift-up
    bindkey -M viins '^[[1;2B' shift-down
    
    # Fix for Option+Backspace in tmux
    bindkey -M viins '^[^?' backward-kill-word
    bindkey -M viins '^[[3;3~' kill-word  # Option+Delete
fi

if command -v sketchybar &>/dev/null; then
    sketchybar --reload

    function brew() {
        command brew "$@"
        if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]] || [[ $* =~ "list" ]] || [[ $* =~ "install" ]] || [[ $* =~ "uninstall" ]] || [[ $* =~ "bundle" ]] || [[ $* =~ "doctor" ]] || [[ $* =~ "info" ]] || [[ $* =~ "cleanup" ]]; then
            sketchybar --trigger brew_update
        fi
    }
fi

# ============================================================================
# VS CODE-LIKE LAYOUT ALIASES
# ============================================================================

# Quick development layout setup
alias devlayout='bash ~/.config/scripts/dev-layout.sh'
alias tmuxdev='bash ~/.config/scripts/tmux-dev-layout.sh'
alias vscode-layout='devlayout'

# File managers for sidebar
alias files='lf'
alias fm='ranger'
alias tree2='tree -L 2'
alias tree3='tree -L 3'

# Quick project navigation
alias dev='cd ~/dev'
alias config='cd ~/.config'
alias notes='cd ~/notes'
alias workspace='cd ~/workspace'

# Development workflow helpers
alias nvim.='nvim .'
alias code.='code .'
alias idea.='open -a "IntelliJ IDEA" .'

# Git shortcuts for terminal pane
alias gs='git status'
alias gl='git log --oneline -10'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'

# Quick file operations
alias la='ls -la'
alias ll='ls -l'
alias lt='ls -lt'
alias lsize='ls -lhS'

# Development server shortcuts
alias serve='python3 -m http.server'
alias serve8080='python3 -m http.server 8080'

# File browser helper alias
alias clearecho='clear && echo'

