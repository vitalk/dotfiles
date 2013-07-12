#!/usr/bin/env bash
# install.sh
# this is an installation script

SUCCESS=0
E_BAD_PARAMS=1

RED="\033[1;31m"
GREEN="\033[1;32m"
RESET="\033[m"

target_dir=~
source_dir="$(cd "$(dirname "$0")" > /dev/null; pwd)"


# echoes fancy text
# Usage: echook <fancy text>
function echook() {
    echo -e ${GREEN}$*${RESET}
}

function echofail() {
    echo -e ${RED}$*${RESET}
}

# print usage help and exit
function usage() {
    echook "Usage: $(basename "$0") [-h|--help] [-F|--force] [--prefix=$HOME]";
    echook
    echook "This script will pull the latest changes from repos and install"
    echook "the files into your home directory."
    echook
    echook "  -f, --force         ignore existing files, never prompt"
    echook "  -h, --help          display this help and exit"
    echook "  --prefix=PATH       prefix, where to install(empty for home dir)"
}


# actually do it!
# 1. fetch the latest version from repository
# 2. create a symlinks to source directory
function doit() {
    fetch-latest-version

    for f in $(ls -A1 | grep -v \
         -e '.git' \
         -e '.gitmodules' \
         -e '*.sw?' \
         -e 'README' \
         -e 'install.sh' \
         ); do

        target="$target_dir/$f"
        if [ -e "$target" ]; then
            if [ ! -L "$target" ]; then
                echofail "WARNING: $target exists but it is not a symlink"
            fi
        else
            echook "Creating $target"
            ln -s "$source_dir/$f" "$target"
        fi
    done

    #install-git-completion

    echofail Well done
}

# fetch the latest version from repos
function fetch-latest-version() {
    echook "Get latest version from origin remote."
    echook "This may take awhile..."

    cd "$( dirname "$0" )"
    git pull origin master
    git submodule --quiet update --init
}

# fetch git completion to target directory
function install-git-completion() {
    echook Fetch git completion...
    curl -s https://raw.github.com/git/git/master/contrib/completion/git-completion.bash \
        -o "$target_dir"/.bash/completion/git-completion.bash
}

# prompt before do it
function run() {
    echofail "Be patient! This action may overwrite existing files on your target directory('$target_dir'). "
    read -n 1 -p "Are you sure? (y/[N]) "
    echo
    if [[ $REPLY =~ ^[yY]$ ]]; then
        doit;
    else
        echofail aborted
    fi
}

while (($#)); do
    case "$1" in
        --prefix=*)
            target_dir+="/${1#--prefix=}";
            ;;
        -f|--force)
            doit;
            exit $SUCCESS;
            ;;
        -h|--help)
            usage;
            exit $SUCCESS;
            ;;
        *)
            [ "$1" == "--" ] && shift;
            if (($#)); then
                usage;
                exit $E_BAD_PARAMS;
            fi;
    esac
        shift;
done;

run
