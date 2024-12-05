#compdef dufs

autoload -U is-at-least

_dufs() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" : \
'-c+[Specify configuration file]:file:_files' \
'--config=[Specify configuration file]:file:_files' \
'*-b+[Specify bind address or unix socket]:addrs:_default' \
'*--bind=[Specify bind address or unix socket]:addrs:_default' \
'-p+[Specify port to listen on \[default\: 5000\]]:port:_default' \
'--port=[Specify port to listen on \[default\: 5000\]]:port:_default' \
'--path-prefix=[Specify a path prefix]:path:_default' \
'*--hidden=[Hide paths from directory listings, e.g. tmp,*.log,*.lock]:value:_default' \
'*-a+[Add auth roles, e.g. user\:pass@/dir1\:rw,/dir2]:rules:_default' \
'*--auth=[Add auth roles, e.g. user\:pass@/dir1\:rw,/dir2]:rules:_default' \
'--auth-method=[Select auth method]:value:(basic digest)' \
'--assets=[Set the path to the assets directory for overriding the built-in assets]:path:_files' \
'--log-format=[Customize http log format]:format:_default' \
'--log-file=[Specify the file to save logs to, other than stdout/stderr]:file:_files' \
'--compress=[Set zip compress level \[default\: low\]]:level:(none low medium high)' \
'--completions=[Print shell completion script for <shell>]:shell:(bash elvish fish powershell zsh)' \
'--tls-cert=[Path to an SSL/TLS certificate to serve with HTTPS]:path:_files' \
'--tls-key=[Path to the SSL/TLS certificate'\''s private key]:path:_files' \
'-A[Allow all operations]' \
'--allow-all[Allow all operations]' \
'--allow-upload[Allow upload files/folders]' \
'--allow-delete[Allow delete files/folders]' \
'--allow-search[Allow search files/folders]' \
'--allow-symlink[Allow symlink to files/folders outside root directory]' \
'--allow-archive[Allow zip archive generation]' \
'--enable-cors[Enable CORS, sets \`Access-Control-Allow-Origin\: *\`]' \
'--render-index[Serve index.html when requesting a directory, returns 404 if not found index.html]' \
'--render-try-index[Serve index.html when requesting a directory, returns directory listing if not found index.html]' \
'--render-spa[Serve SPA(Single Page Application)]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'::serve-path -- Specific path to serve \[default\: .\]:_files' \
&& ret=0
}

(( $+functions[_dufs_commands] )) ||
_dufs_commands() {
    local commands; commands=()
    _describe -t commands 'dufs commands' commands "$@"
}

if [ "$funcstack[1]" = "_dufs" ]; then
    _dufs "$@"
else
    compdef _dufs dufs
fi
