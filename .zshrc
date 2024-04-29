# Enable this to measures zsh startup performance problems
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# These are default plugins that will be synced by git across all usages.
# To add your custom plugins for a specific computer, add them in 
# custom-omz-plugins.sh, so that it won't be tracked by git.
default_plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    extract
    z
    vi-mode
    colored-man-pages
)

# Load custom plugins
source "$DOTFILES_ROOT/custom-omz-plugins.sh"
plugins=("${default_plugins[@]}" "${custom_additional_plugins[@]}")

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Locd powerlevel10k settings
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source alias in this dotfiles repo
__source alias

# Source functions in this dotfiles repo
__source func
