#!/usr/bin/env bash

SOURCE=~/.bash

# Usage: load name [name ...]
# load file or files from endpoint location, if endpoint is a directory, then
# all contained files are loaded.
function load() {
    local subdir file files

    # try to load source from file
    subdir="$1"
    if [[ -f "${SOURCE}/${subdir}" && -r "${SOURCE}/${subdir}" ]]; then
        source "${SOURCE}/${subdir}"
        continue
    fi

    # if passed param is dir load all from it
    files="$SOURCE/$subdir/*"
    for file in $files; do
        # load global config
        if [[ -e "$file" && -r "$file" ]]; then
            source "$file"
        fi
        # then local
        if [[ -e "$file.local" && -r "$file.local" ]]; then
            source "$file.local"
        fi
    done
}

# this allow use Ctrl + S on Vim mappings
stty -ixoff -ixon

# add various sbins to our PATH
PATH="$PATH:/sbin:/usr/sbin:/usr/local/sbin"
PATH="$PATH:/usr/local/bin"

# put ~/.bin on PATH too
[ -d ~/.bin ] && PATH="$HOME/.bin:$PATH"

# load global and local aliases, completions, functions, etc.
for file in aliases{,.local} \
    exports{,.local} \
    functions{,.local} \
    hooks{,.local} \
    completion{,.local} \
    prompt{,.local}; \
do
    load $file
done
unset file
