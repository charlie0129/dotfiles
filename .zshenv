OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Source env definitions in this dotfiles repo
# Note that what sourced first will actually have lower priority in PATH due to how it works
# OS specific definitions
if [ -f "$HOME/dotfiles/env/darwin.sh" ] && [ "${OS}" = "darwin" ]; then
    source "$HOME/dotfiles/env/darwin.sh"
fi
# OS specific definitions
if [ -f "$HOME/dotfiles/env/linux.sh" ] && [ "${OS}" = "linux" ]; then
    source "$HOME/dotfiles/env/linux.sh"
fi
# Load common definitions
if [ -f "$HOME/dotfiles/env/common.sh" ]; then
    source "$HOME/dotfiles/env/common.sh"
fi
# Custom definition always loads first
if [ -f "$HOME/dotfiles/env/custom.sh" ]; then
    source "$HOME/dotfiles/env/custom.sh"
fi
# Source complete