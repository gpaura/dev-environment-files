# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export TERM_BOLD=1

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$PATH:$(go env GOPATH)/bin"
export PROMPT='%B'"$PROMPT"'%b'
export RPROMPT='%B'"$RPROMPT"'%b'
# Reevaluate the prompt string each time it's displaying a prompt
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit
source <(kubectl completion zsh)
complete -C '/usr/local/bin/aws_completer' aws

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

export LANG=en_US.UTF-8

export EDITOR=/opt/homebrew/bin/nvim

alias la=tree
alias cat=bat

# Git
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

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias cl='clear'

# HTTP requests with xh!
alias http="xh"

# VI Mode!!! - Fixed to prevent Option+Delete conflicts
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

# Keep normal macOS delete behavior
bindkey '^[[3~' delete-char              # Delete key
bindkey '^?' backward-delete-char        # Backspace
bindkey '\e[3~' delete-char             # Alternative delete
bindkey '^H' backward-delete-char        # Ctrl+H (backspace)

# macOS specific key bindings - These prevent Option+Delete from triggering jj
bindkey '\e^?' backward-kill-word        # Option+Delete (backward kill word)
bindkey '\e\d' backward-kill-word        # Alt+Delete (alternative)
bindkey '^W' backward-kill-word          # Ctrl+W (backward kill word)
bindkey '^[^?' backward-kill-word        # Another Option+Delete variant
bindkey '\e^H' backward-kill-word        # Option+Backspace

# macOS Command key shortcuts (like in Mac text fields)
# Command+Delete/Backspace - Delete to beginning of line
bindkey '^[[3;2~' backward-kill-line     # Cmd+Delete 
bindkey '\e[3;2~' backward-kill-line     # Cmd+Delete (alternative)
bindkey '^[[127;2u' backward-kill-line   # Cmd+Backspace
bindkey '^U' backward-kill-line          # Ctrl+U (universal alternative)

# Command+Z - Undo last edit (WezTerm specific sequence)
bindkey '^Z^C' undo                      # Cmd+Z - undo (WezTerm sends ^Z^C)
bindkey '^Z' undo                        # Cmd+Z - undo (fallback)
bindkey '^[[122;2u' undo                 # Cmd+Z (alternative sequence)
bindkey '\e[122;2u' undo                 # Cmd+Z (another alternative)

# Command+Arrow Keys - Navigation like macOS (WezTerm specific sequences)
bindkey '^[[D' beginning-of-line         # Cmd+Left - go to beginning of line (WezTerm)
bindkey '^[[C' end-of-line               # Cmd+Right - go to end of line (WezTerm)

# Backup sequences for other terminals
bindkey '^[[1;10D' beginning-of-line     # Cmd+Left (alternative)
bindkey '^[[1;10C' end-of-line           # Cmd+Right (alternative)
bindkey '^[[1;2D' beginning-of-line      # Cmd+Left (another alternative)
bindkey '^[[1;2C' end-of-line            # Cmd+Right (another alternative)
bindkey '\e[1;2D' beginning-of-line      # Cmd+Left (escape variant)
bindkey '\e[1;2C' end-of-line            # Cmd+Right (escape variant)
bindkey '^[[H' beginning-of-line         # Cmd+Left (Home key)
bindkey '^[[F' end-of-line               # Cmd+Right (End key)

# Command+Up/Down
bindkey '^[[1;10A' beginning-of-buffer-or-history  # Cmd+Up - go to top
bindkey '^[[1;10B' end-of-buffer-or-history        # Cmd+Down - go to bottom

# Option+Arrow Keys - Word movement (setas + option)
bindkey '^[[1;3D' backward-word          # Option+Left - move left by word
bindkey '^[[1;3C' forward-word           # Option+Right - move right by word
bindkey '\e[1;3D' backward-word          # Option+Left (alternative)
bindkey '\e[1;3C' forward-word           # Option+Right (alternative)
bindkey '\eb' backward-word              # Option+Left (universal)
bindkey '\ef' forward-word               # Option+Right (universal)

# Command+A/E - Line navigation
bindkey '^A' beginning-of-line           # Cmd+A - go to beginning of line
bindkey '^E' end-of-line                 # Cmd+E - go to end of line

# Command+K - Delete to end of line
bindkey '^K' kill-line                   # Cmd+K - kill to end of line

# Better vi mode indicators (optional)
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[1 q'  # Block cursor for normal mode
  else
    echo -ne '\e[5 q'  # Beam cursor for insert mode
  fi
}
zle -N zle-keymap-select

# Initialize with beam cursor
echo -ne '\e[5 q'

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# Set EZA_COLORS environment variable to make directories purple
# export EZA_COLORS="di=35:$EZA_COLORS"
# export EZA_COLORS="di=1;35:fi=1;37:ln=1;36:$EZA_COLORS"
export EZA_COLORS="di=1;35:fi=1;37:ln=1;36:pi=1;33:so=1;35:bd=1;33:cd=1;33:or=1;31:mi=1;31:ex=1;32:$EZA_COLORS"

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/Users/gabrielpaura/.spicetify

export PATH="$HOME/.rbenv/shims:$PATH"

# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --type f --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
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

# ----- Bat (better cat) -----

export BAT_THEME=tokyonight_night

# ---- Eza (better ls) -----
# ---- Eza (better ls) -----

#alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ls="eza --color=always --icons=always"
alias lt2="eza -lTg --level=2 --icons=always"
alias lt3="eza -lTg --level=3 --icons=always"
alias lta2="eza -lTag --level=2 --icons=always"
alias lta3="eza -lTag --level=3 --icons=always"

#Tmux alias
alias tks='tmux kill-session -t'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'

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

# ---- TheFuck -----

# thefuck alias
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

alias nu='nu --config ~/.config/nushell/config.nu'
alias cd='z'
alias ..='cd ..'
alias ll='ls -l'
alias theme='~/theme.sh'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/bin:$PATH"

if command -v atuin > /dev/null 2>&1; then
    eval "$(atuin init zsh)"
fi

	# sketchybar
	# This will update the brew package count after running a brew upgrade, brew
	# update or brew outdated command
	# Personally I added "list" and "install", and everything that is after but
	# that's just a personal preference.
	# That way sketchybar updates when I run those commands as well
	if command -v sketchybar &>/dev/null; then

		# When the zshrc file is ran, reload sketchybar, in case the theme was
		# switched
		sketchybar --reload

		# Define a custom 'brew' function to wrap the Homebrew command.
		function brew() {
			# Execute the original Homebrew command with all passed arguments.
			command brew "$@"
			# Check if the command includes "upgrade", "update", or "outdated".
			if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]] || [[ $* =~ "list" ]] || [[ $* =~ "install" ]] || [[ $* =~ "uninstall" ]] || [[ $* =~ "bundle" ]] || [[ $* =~ "doctor" ]] || [[ $* =~ "info" ]] || [[ $* =~ "cleanup" ]]; then
				# If so, notify SketchyBar to trigger a custom action.
				sketchybar --trigger brew_update
			fi
		}
	fi

# Created by `pipx` on 2025-07-07 16:58:06
export PATH="$PATH:/Users/gabrielpaura/.local/bin"
