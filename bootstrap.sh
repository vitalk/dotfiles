#!/bin/bash
# bootstrap.sh
# this is an installation script, but it replace your existing files, be
# careful and read it before install!

SUCCESS=0
E_BAD_PARAMS=1

target_dir=~
source_dir="$(cd "$(dirname "$0")" > /dev/null; pwd)"

git pull
git submodule --quiet update --init

function usage() {
    echo "Usage: $(basename "$0") [-h|--help] [-f|--force] [--prefix=$HOME]";
    echo "This script will pull in the latest changes and copy the files to"
    echo "your home directory."
    echo
    echo "  -f, --force         ignore existing files, never prompt"
    echo "  -h, --help          display this help and exit"
    echo "  --prefix=PATH       prefix, where to install(empty for home dir)"
}

function doIt() {
    rsync -ahv --exclude "*.sw?" --exclude ".git/" --exclude "bootstrap.sh" --exclude 'README.md' "$source_dir/" "$target_dir"
    echo well done
}

function run() {
    read -n 1 -p "Be patient! This action may overwrite existing files on your target directory('$target_dir'). Are you sure? (y/[N]) "
    echo
    if [[ $REPLY =~ ^[yY]$ ]]; then
        doIt;
    fi
}

while (($#)); do
    case "$1" in
        --prefix=*)
            target_dir+="/${1#--prefix=}";
            ;;
        -f|--force)
            doIt;
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

unset doIt
unset run
unset usage
cd "${OLDPWD}"
source ~/.bash_profile

exit $SUCCESS;
