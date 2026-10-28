############################ BEGIN zsh4humans .zshenv ############################

# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.
#
# Do not modify this file unless you know exactly what you are doing.
# It is strongly recommended to keep all shell customization and configuration
# (including exported environment variables such as PATH) in ~/.zshrc or in
# files sourced from ~/.zshrc. If you are certain that you must export some
# environment variables in ~/.zshenv, do it where indicated by comments below.

if [ -n "${ZSH_VERSION-}" ]; then
  # If you are certain that you must export some environment variables
  # in ~/.zshenv (see comments at the top!), do it here:
  #
  #   export GOPATH=$HOME/go
  #
  # Do not change anything else in this file.

  # Coding agents (Claude Code, Codex) write bash but run it with `zsh -c`.
  # Give those command strings bash-like word splitting, globbing (unmatched
  # patterns stay literal, no `=cmd`), echo, redirections and `${a[0]}`.
  # Agent env vars don't survive ssh, so also match what sshd runs for
  # `ssh host 'cmd'` (SSH_CONNECTION set, SHLVL 1). Scripts and interactive
  # shells keep zsh semantics. Must stay above the z4h `return` below, and
  # `{ }` instead of `[[ ( ) ]]` keeps this file parseable by sh, which
  # sources it during z4h bootstrap.
  if [[ ! -o interactive && -n ${ZSH_EXECUTION_STRING+x} ]] && {
    [[ -n ${CLAUDECODE-}${CODEX_THREAD_ID-} ]] ||
    [[ -n ${SSH_CONNECTION-} && $SHLVL == 1 ]]
  }; then
    setopt sh_word_split ksh_zero_subscript typeset_silent no_bg_nice \
      no_nomatch no_bad_pattern no_equals bsd_echo no_multios sh_nullcmd
  fi

  : ${ZDOTDIR:=~}
  setopt no_global_rcs
  [[ -o no_interactive && -z "${Z4H_BOOTSTRAPPING-}" ]] && return
  setopt no_rcs
fi

Z4H_URL="https://raw.githubusercontent.com/romkatv/zsh4humans/v5"
: "${Z4H:=${XDG_CACHE_HOME:-$HOME/.cache}/zsh4humans/v5}"

umask o-w

if [ ! -e "$Z4H"/z4h.zsh ]; then
  mkdir -p -- "$Z4H" || return
  >&2 printf '\033[33mz4h\033[0m: fetching \033[4mz4h.zsh\033[0m\n'
  echo "We need to download some files from the internet."
  if [ ! -t 0 ] && [ -z "${Z4H_BOOTSTRAPPING-}" ]; then
    >&2 printf '\033[33mz4h\033[0m: stdin is not a terminal and Z4H_BOOTSTRAPPING is not set.\n'
    >&2 printf 'You may want to install z4h non-interactively (e.g. in a Dockerfile): %s\n' "Z4H_BOOTSTRAPPING=1 zsh -c '[[ -r \$Z4H/zsh4humans/main.zsh ]]'"
    >&2 printf 'Need a proxy to reach GitHub? export http_proxy/https_proxy first.\n'
  elif [ -z "${Z4H_BOOTSTRAPPING-}" ] && read -q "choice?Do you need to use a proxy? This is useful if your current network cannot access GitHub. [y/n]: "; then
      echo
      echo "Just fill some plain old proxy-related environment variables. Leave empty to skip."
      read "http_proxy?- http_proxy="
      export http_proxy
      export HTTP_PROXY=$http_proxy
      read "https_proxy?- https_proxy="
      export https_proxy
      export HTTPS_PROXY=$https_proxy
      read "no_proxy?- no_proxy="
      export no_proxy
      export NO_PROXY=$no_proxy
  fi
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -- "$Z4H_URL"/z4h.zsh >"$Z4H"/z4h.zsh.$$ || return
  elif command -v wget >/dev/null 2>&1; then
    wget -O-   -- "$Z4H_URL"/z4h.zsh >"$Z4H"/z4h.zsh.$$ || return
  else
    >&2 printf '\033[33mz4h\033[0m: please install \033[32mcurl\033[0m or \033[32mwget\033[0m\n'
    return 1
  fi
  mv -- "$Z4H"/z4h.zsh.$$ "$Z4H"/z4h.zsh || return
fi

unset Z4H_BOOTSTRAPPING

. "$Z4H"/z4h.zsh || return

setopt rcs

############################ END zsh4humans .zshenv ############################
