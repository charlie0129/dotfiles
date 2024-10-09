# Enable this to measures zsh startup performance problems
# zmodload zsh/zprof

############################ BEGIN zsh4humans .zshrc ############################

# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update 'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard 'mac'

# Don't start tmux.
zstyle ':z4h:' start-tmux no

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv' enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1' enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*' enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Define key bindings.
z4h bindkey undo Ctrl+/ Shift+Tab # undo the last command line change
z4h bindkey redo Option+/         # redo the last undone command line change

z4h bindkey z4h-cd-back Shift+Left     # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right # cd into the next directory
z4h bindkey z4h-cd-up Shift+Up         # cd into the parent directory
z4h bindkey z4h-cd-down Shift+Down     # cd into a child directory

############################ END zsh4humans .zshrc ############################

############################ BEGIN Load dotfile defs ############################

# DOTFILES_ROOT indicates the directory for this repo.
# Use this variable instead of hard-coded ~/dotfiles.
export DOTFILES_ROOT="$(dirname $(readlink ~/.zshrc))"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

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
            z4h source "$DOTFILES_ROOT/$1/$type.sh"
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

############################ BEGIN omz plugins ############################

# These are default plugins that will be synced by git across all usages.
# To add your custom plugins for a specific computer, add them in
# custom-omz-plugins.sh, so that it won't be tracked by git.
default_plugins=(
    git
    extract
    z
    colored-man-pages
)

# Load custom plugins
source "$DOTFILES_ROOT/custom-omz-plugins.sh"
plugins_all=("${default_plugins[@]}" "${custom_additional_plugins[@]}")

for p in "${plugins_all[@]}"; do
    z4h load ohmyzsh/ohmyzsh/plugins/$p
done

############################ END omz plugins ############################

############################ BEGIN Shell Opts ############################

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots    # no special treatment for file names with a leading dot
setopt no_auto_menu # require an extra TAB press to open the completion menu

############################ END Shell Opts ############################
