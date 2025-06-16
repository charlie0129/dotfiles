#!/usr/bin/env bash

function link_files() {
    local os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    for type in common "$os" custom; do
        if [ -f ".pathmapping.$type" ]; then
            __link_files ".pathmapping.$type"
        fi
    done
}

function __link_files() {
    pathmapping_file="$1"
    if [[ ! -f "$pathmapping_file" ]]; then
        echo "Path mapping file '$pathmapping_file' does not exist."
        return 1
    fi

    # Read `.pathmapping file' into array line by line
    IFS=$'\n' read -d "" -ra file_data <"$pathmapping_file"

    for element in "${file_data[@]}"; do
        # Ignore comments
        if [[ $element == \#* ]]; then
            continue
        fi

        # Split string by colon
        IFS=':' read -ra splitted <<<"$element"
        # Make sure splitted has 2 elements
        if [ ${#splitted[@]} -ne 2 ]; then
            echo "Invalid line: $element"
            continue
        fi

        # Get source and destination
        src="$PWD/$(eval echo ${splitted[0]})"
        dst="$(eval echo ${splitted[1]})"

        printf "Linking '%s' to '%s'" "$src" "$dst"
        # If dst already exists. -e does not cover all cases (when symlink is not valid)
        # so we also check if it's a symlink
        if [[ -e "$dst" || -L "$dst" ]]; then
            # If it's a symlink
            if [ -L "$dst" ]; then
                # If it's a symlink to src
                if [ "$(readlink "$dst")" == "$src" ]; then
                    printf "${COLOR_GREEN}%s${COLOR_RESET}\n" " - already linked"
                    continue
                fi
            fi

            # If it's not a symlink, or it's a symlink to something else
            if [ "$FORCE" == "y" ]; then
                printf "${COLOR_YELLOW}%s${COLOR_RESET}\n" " - overwriting"
                rm -rf "$dst"
            else
                printf "${COLOR_YELLOW}%s${COLOR_RESET}\n" " - skipped (file already exists, use -f to overwrite)"
                continue
            fi
        fi
        printf "..."
        # Make sure parent directory exists
        mkdir -p "$(dirname "$dst")"
        # Create symlink
        ln -s "$src" "$dst"
        printf "\n"
    done
}
