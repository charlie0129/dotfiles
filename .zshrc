export DOTFILES_ROOT="$(dirname $(readlink ~/.zshrc))"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Measures zsh startup performance problems
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$DOTFILES_ROOT/dep/ohmyzsh"

ZSH_DISABLE_COMPFIX=true

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Customize zsh-autosuggestions settings
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Show prompt changes if mode changes in vi mode
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

# Load custom plugins
source "$DOTFILES_ROOT/custom-omz-plugins.sh"

# These are default plugins.
# To add your custom plugins, add them in custom-omz-plugins.sh,
# so that it won't be tracked by git.
default_plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    extract
    z
    vi-mode
    colored-man-pages
)

plugins=("${default_plugins[@]}" "${custom_additional_plugins[@]}")

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR="vim"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Locd powerlevel10k settings
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source env definitions in this dotfiles repo
# Note that what sourced first will actually have lower priority in PATH due to how it works
# OS specific definitions
if [ -f "$DOTFILES_ROOT/env/${OS}.sh" ]; then
    source "$DOTFILES_ROOT/env/${OS}.sh"
fi
# Load common definitions
if [ -f "$DOTFILES_ROOT/env/common.sh" ]; then
    source "$DOTFILES_ROOT/env/common.sh"
fi
# Custom definition always loads first
if [ -f "$DOTFILES_ROOT/env/custom.sh" ]; then
    source "$DOTFILES_ROOT/env/custom.sh"
fi
# Source complete

# Source alias in this dotfiles repo
# OS specific alias
if [ -f "$DOTFILES_ROOT/alias/${OS}.sh" ]; then
    source "$DOTFILES_ROOT/alias/${OS}.sh"
fi
# Load common alias
if [ -f "$DOTFILES_ROOT/alias/common.sh" ]; then
    source "$DOTFILES_ROOT/alias/common.sh"
fi
# Custom alias always have higher priority
if [ -f "$DOTFILES_ROOT/alias/custom.sh" ]; then
    source "$DOTFILES_ROOT/alias/custom.sh"
fi

