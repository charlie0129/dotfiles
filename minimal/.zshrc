# DOTFILES_ROOT indicates the directory for this repo.
# Use this variable instead of hard-coded ~/dotfiles.
export DOTFILES_ROOT="$(dirname $(readlink ~/.zshrc))"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# -- early vars
export VISUAL=vim
export EDITOR=vim
alias e=$EDITOR

# -- zsh modules
autoload -Uz zcalc
autoload -Uz compinit

# -- antibody
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd)
PURE_GIT_PULL=0

# polyfill for prezto dependency loader
pmodload() {}

zstyle ':prezto:*:*' color yes
zstyle ':prezto:module:editor' key-bindings emacs
zstyle ':prezto:module:editor' dot-expansion yes
zstyle ':prezto:module:utility' safe-ops no
zstyle ':prezto:module:gnu-utility' prefix g
zstyle ':prezto:module:git:alias' skip yes

mkc() {
    mkdir -p "$1" && cd "$1" || return 1
}

# before completion module
_mkc() {
    #compdef mkc
    _files -W "$1" -/
}

if [[ -z "$ZDOTDIR" ]]; then
    export ZDOTDIR=$HOME
fi

source $DOTFILES_ROOT/cache/zsh-users_zsh-completions/zsh-completions.plugin.zsh
fpath+=( $DOTFILES_ROOT/cache/zsh-users_zsh-completions )

source $DOTFILES_ROOT/cache/mafredri_zsh-async/async.plugin.zsh
fpath+=( $DOTFILES_ROOT/cache/mafredri_zsh-async )

source $DOTFILES_ROOT/cache/sindresorhus_pure/pure.plugin.zsh
fpath+=( $DOTFILES_ROOT/cache/sindresorhus_pure )


source $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/helper/init.zsh
fpath+=( $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/helper )

source $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/spectrum/init.zsh
fpath+=( $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/spectrum )

source $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/environment/init.zsh
fpath+=( $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/environment )

source $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/terminal/init.zsh
fpath+=( $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/terminal )

source $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/editor/init.zsh
fpath+=( $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/editor )

source $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/gnu-utility/init.zsh
fpath+=( $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/gnu-utility )

source $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/utility/init.zsh
fpath+=( $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/utility )

source $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/git/init.zsh
fpath+=( $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/git )

source $DOTFILES_ROOT/cache/zdharma-continuum_fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fpath+=( $DOTFILES_ROOT/cache/zdharma-continuum_fast-syntax-highlighting )

source $DOTFILES_ROOT/cache/zsh-users_zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
fpath+=( $DOTFILES_ROOT/cache/zsh-users_zsh-autosuggestions )

source $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/completion/init.zsh
fpath+=( $DOTFILES_ROOT/cache/sorin-ionescu_prezto/modules/completion )

# -- flags
setopt AUTO_CD
setopt CDABLE_VARS
setopt MULTIOS
setopt EXTENDED_GLOB
setopt CLOBBER
setopt MENU_COMPLETE
setopt PUSHDSILENT

# history
setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing non-existent history.
setopt glob_dots              # no special treatment for file names with a leading dot


# -- aliases
alias .='source'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# -- tweaks
if [ -z "$HISTFILE" ]; then
    export HISTFILE="$ZDOTDIR/.zsh_history"
fi
HISTSIZE=100000 # in memory
SAVEHIST=100000 # persistent
bindkey -e # emacs keymap
# disable correction - requires rehash after pkg install
unsetopt correct

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# rehash if command not found (possibly recently installed)
zstyle ':completion:*' rehash true

# menu if nb items > 2
zstyle ':completion:*' menu select=2

############################ BEGIN Load dotfile defs ############################
# Source helper. This is used to load env/alias/func definitions in this repo in the correct order.
__source() {
    if [ -z "$1" ]; then
        echo "Usage: __source <env|alias|func>"
        return 1
    fi
    # check for existence of the directory
    if [ ! -d "$DOTFILES_ROOT/$1" ]; then
        echo "Directory $DOTFILES_ROOT/$1 does not exist."
        return 1
    fi
    # Note that what sourced first will actually have lower priority.
    # So custom env definitions have a priority like this: custom > os-specific > common
    local types=(
        common
        $OS
        custom # Custom definition always have higher priority
    )
    for type in "${types[@]}"; do
        if [ -f "$DOTFILES_ROOT/$1/$type.sh" ]; then
            source "$DOTFILES_ROOT/$1/$type.sh"
        fi
    done
}

# Load env definitions
__source env

# Source alias in this dotfiles repo
__source alias

# Source functions in this dotfiles repo
__source func

############################ END Load dotfile defs ############################

############################ BEGIN Completions ############################

# check for existence of the directory
if [ ! -d "$DOTFILES_ROOT/completions" ]; then
    echo "Directory $DOTFILES_ROOT/completions does not exist." >&2
fi
# Note that what sourced first will actually have lower priority.
# So custom env definitions have a priority like this: custom > os-specific > common
local types=(
    common
    $OS
    custom # Custom definition always have higher priority
)
for type in "${types[@]}"; do
    for i in $(find "$DOTFILES_ROOT/completions/$type" -type f -name '*.zsh'); do
        source "$i"
    done
done

############################ END Completions ############################
