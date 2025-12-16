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

# ============================================================================
# LS_COLORS - Matching nvim-tree Monokai Pro Octagon color palette
# ============================================================================
# Format: type=color_code
# Colors match nvim-tree configuration:
# - Directories (di): Yellow (#FFD866 = 38;5;221) - folder icons and names in yellow
# - Regular files (fi): White (#FCFCFA = 38;5;231)
# - Symlinks (ln): Cyan (#78DCE8 = 38;5;117)
# - Executables (ex): Green (#A9DC76 = 38;5;113)
# File extensions match nvim-web-devicons colors

export LS_COLORS='rs=0:di=38;5;221:ln=38;5;117:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=38;5;113:*.tar=38;5;227:*.tgz=38;5;227:*.arc=38;5;227:*.arj=38;5;227:*.taz=38;5;227:*.lha=38;5;227:*.lz4=38;5;227:*.lzh=38;5;227:*.lzma=38;5;227:*.tlz=38;5;227:*.txz=38;5;227:*.tzo=38;5;227:*.t7z=38;5;227:*.zip=38;5;227:*.z=38;5;227:*.dz=38;5;227:*.gz=38;5;227:*.lrz=38;5;227:*.lz=38;5;227:*.lzo=38;5;227:*.xz=38;5;227:*.zst=38;5;227:*.tzst=38;5;227:*.bz2=38;5;227:*.bz=38;5;227:*.tbz=38;5;227:*.tbz2=38;5;227:*.tz=38;5;227:*.deb=38;5;227:*.rpm=38;5;227:*.jar=38;5;208:*.war=38;5;227:*.ear=38;5;227:*.sar=38;5;227:*.rar=38;5;227:*.alz=38;5;227:*.ace=38;5;227:*.zoo=38;5;227:*.cpio=38;5;227:*.7z=38;5;227:*.rz=38;5;227:*.cab=38;5;227:*.wim=38;5;227:*.swm=38;5;227:*.dwm=38;5;227:*.esd=38;5;227:*.jpg=38;5;140:*.jpeg=38;5;140:*.mjpg=38;5;140:*.mjpeg=38;5;140:*.gif=38;5;140:*.bmp=38;5;140:*.pbm=38;5;140:*.pgm=38;5;140:*.ppm=38;5;140:*.tga=38;5;140:*.xbm=38;5;140:*.xpm=38;5;140:*.tif=38;5;140:*.tiff=38;5;140:*.png=38;5;140:*.svg=38;5;214:*.svgz=38;5;140:*.mng=38;5;140:*.pcx=38;5;140:*.mov=38;5;208:*.mpg=38;5;208:*.mpeg=38;5;208:*.m2v=38;5;208:*.mkv=38;5;208:*.webm=38;5;208:*.ogm=38;5;208:*.mp4=38;5;208:*.m4v=38;5;208:*.mp4v=38;5;208:*.vob=38;5;208:*.qt=38;5;208:*.nuv=38;5;208:*.wmv=38;5;208:*.asf=38;5;208:*.rm=38;5;208:*.rmvb=38;5;208:*.flc=38;5;208:*.avi=38;5;208:*.fli=38;5;208:*.flv=38;5;208:*.gl=38;5;208:*.dl=38;5;208:*.xcf=38;5;208:*.xwd=38;5;208:*.yuv=38;5;208:*.cgm=38;5;208:*.emf=38;5;208:*.ogv=38;5;208:*.ogx=38;5;208:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.m4a=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.oga=38;5;45:*.opus=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:*.js=38;5;221:*.jsx=38;5;117:*.ts=38;5;74:*.tsx=38;5;117:*.py=38;5;74:*.pyc=38;5;74:*.go=38;5;80:*.rs=38;5;166:*.java=38;5;208:*.c=38;5;111:*.cpp=38;5;74:*.cc=38;5;74:*.h=38;5;111:*.hpp=38;5;74:*.cs=38;5;113:*.php=38;5;177:*.rb=38;5;161:*.swift=38;5;202:*.lua=38;5;74:*.vim=38;5;113:*.html=38;5;202:*.htm=38;5;202:*.css=38;5;38:*.scss=38;5;168:*.sass=38;5;168:*.less=38;5;38:*.vue=38;5;77:*.json=38;5;185:*.jsonc=38;5;185:*.yaml=38;5;124:*.yml=38;5;124:*.toml=38;5;166:*.xml=38;5;208:*.md=38;5;74:*.markdown=38;5;74:*.txt=38;5;113:*.pdf=38;5;196:*.doc=38;5;74:*.docx=38;5;74:*.sh=38;5;71:*.bash=38;5;71:*.zsh=38;5;113:*.fish=38;5;71:*.sql=38;5;196:*.db=38;5;248:*.sqlite=38;5;74:*.log=38;5;245:*.tmp=38;5;240:*.bak=38;5;240:*.swp=38;5;240:'

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
    zle reset-prompt 2>/dev/null
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

show-selection-yellow() {
    local start=$1
    local end=$2
    local text="${BUFFER:$start:$((end - start))}"

    echo -ne "\r\033[K"

    if [[ $start -gt 0 ]]; then
        echo -n "${BUFFER:0:$start}"
    fi
    echo -ne "\033[43;30m"
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
    local current_time=$EPOCHREALTIME
    local time_threshold=0.3

    # Check if enough time passed since last selection to reset
    if [[ -n "$LAST_SELECTION_TIME" ]]; then
        local time_diff=$(( current_time - LAST_SELECTION_TIME ))
        if (( $(echo "$time_diff > $time_threshold" | bc -l) )); then
            reset-selection
        fi
    fi

    if [[ $SELECTION_ACTIVE -eq 0 ]]; then
        # First press - start from cursor position
        SELECTION_START=$CURSOR
        if [[ $direction == "left" ]]; then
            zle backward-word
            SELECTION_END=$SELECTION_START
            SELECTION_START=$CURSOR
        else
            zle forward-word
            SELECTION_END=$CURSOR
        fi
        SELECTION_ACTIVE=1
        SELECTION_MODE="word"
    else
        # Extending selection
        if [[ $direction == "left" ]]; then
            zle backward-word
            SELECTION_START=$CURSOR
        else
            zle forward-word
            SELECTION_END=$CURSOR
        fi
    fi

    local selected_text="${BUFFER:$SELECTION_START:$((SELECTION_END - SELECTION_START))}"
    echo -n "$selected_text" | pbcopy

    echo -ne "\033[43;30m"
    if [[ $direction == "left" ]]; then
        echo -n " ← WORD: '$selected_text' "
    else
        echo -n " → WORD: '$selected_text' "
    fi
    echo -ne "\033[0m"
    sleep 0.3
    zle reset-prompt

    # Update timestamp for next call
    LAST_SELECTION_TIME=$EPOCHREALTIME
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
        if [[ \$SELECTION_ACTIVE -eq 1 ]]; then
            reset-selection
            zle reset-prompt
        fi
        zle $widget
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

[ -f ~/.config/fzf-git.sh/fzf-git.sh ] && source ~/.config/fzf-git.sh/fzf-git.sh

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

# LF Colors - Matches nvim-web-devicons configuration
# Format: extension=color_code (using 256-color codes or RGB hex)
export LF_COLORS="\
di=38;5;141:\
fi=38;5;250:\
ln=38;5;81:\
or=38;5;203:\
ex=38;5;118:\
*.js=38;2;247;223;30:\
*.jsx=38;2;97;218;251:\
*.mjs=38;2;247;223;30:\
*.cjs=38;2;247;223;30:\
*.ts=38;2;49;120;198:\
*.tsx=38;2;97;218;251:\
*.py=38;2;55;118;171:\
*.pyc=38;2;108;158;202:\
*.pyo=38;2;108;158;202:\
*.pyd=38;2;108;158;202:\
*.go=38;2;0;173;216:\
*.rs=38;2;206;66;43:\
*.rlib=38;2;206;66;43:\
*.java=38;2;237;139;0:\
*.class=38;2;237;139;0:\
*.jar=38;2;237;139;0:\
*.kt=38;2;127;82;255:\
*.c=38;2;168;185;204:\
*.cpp=38;2;0;89;156:\
*.c++=38;2;0;89;156:\
*.cc=38;2;0;89;156:\
*.cxx=38;2;0;89;156:\
*.h=38;2;168;185;204:\
*.hpp=38;2;0;89;156:\
*.hh=38;2;0;89;156:\
*.hxx=38;2;0;89;156:\
*.cs=38;2;35;145;32:\
*.php=38;2;119;123;180:\
*.rb=38;2;204;52;45:\
*.rake=38;2;204;52;45:\
*.gemspec=38;2;204;52;45:\
*.swift=38;2;240;81;56:\
*.lua=38;2;81;160;207:\
*.vim=38;2;1;151;51:\
*.html=38;2;227;79;38:\
*.htm=38;2;227;79;38:\
*.css=38;2;21;114;182:\
*.scss=38;2;207;100;154:\
*.sass=38;2;207;100;154:\
*.less=38;2;29;54;93:\
*.vue=38;2;79;192;141:\
*.svelte=38;2;255;62;0:\
*.astro=38;2;255;93;1:\
*.json=38;2;203;203;65:\
*.jsonc=38;2;203;203;65:\
*.json5=38;2;203;203;65:\
*.yaml=38;2;203;23;30:\
*.yml=38;2;203;23;30:\
*.toml=38;2;156;66;33:\
*.xml=38;2;227;121;51:\
*.ini=38;2;109;128;134:\
*.md=38;2;81;154;186:\
*.mdx=38;2;81;154;186:\
*.markdown=38;2;81;154;186:\
*.txt=38;2;137;224;81:\
*.pdf=38;2;244;15;2:\
*.doc=38;2;43;87;154:\
*.docx=38;2;43;87;154:\
*.sh=38;2;78;170;37:\
*.bash=38;2;78;170;37:\
*.zsh=38;2;137;224;81:\
*.fish=38;2;74;174;71:\
*.nu=38;2;79;191;93:\
*.ps1=38;2;1;36;86:\
*.sql=38;2;232;39;75:\
*.db=38;2;218;216;216:\
*.sqlite=38;2;0;59;87:\
*.sqlite3=38;2;0;59;87:\
*.png=38;2;160;116;196:\
*.jpg=38;2;160;116;196:\
*.jpeg=38;2;160;116;196:\
*.gif=38;2;160;116;196:\
*.svg=38;2;255;177;59:\
*.ico=38;2;203;203;65:\
*.webp=38;2;160;116;196:\
*.bmp=38;2;160;116;196:\
*.mp4=38;2;253;151;31:\
*.mkv=38;2;253;151;31:\
*.avi=38;2;253;151;31:\
*.mov=38;2;253;151;31:\
*.webm=38;2;253;151;31:\
*.mp3=38;2;0;217;255:\
*.wav=38;2;0;217;255:\
*.flac=38;2;0;217;255:\
*.zip=38;2;249;220;62:\
*.rar=38;2;249;220;62:\
*.7z=38;2;249;220;62:\
*.tar=38;2;249;220;62:\
*.gz=38;2;249;220;62:\
*.bz2=38;2;249;220;62:\
*.log=38;2;175;171;166:\
*.tmp=38;2;108;108;108:\
*.bak=38;2;108;108;108:\
*.swp=38;2;108;108;108:\
"

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

