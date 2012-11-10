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
        if [[ -e "$file" && -r "$file" ]]; then
            source "$file"
        fi
    done
}

# load aliases, completion, etc
for file in aliases exports functions hooks completion prompt; do
    load $file
done
unset file
