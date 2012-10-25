# Dotfiles

A bunch of various configuration files and useful scripts.

## Installation

### Using git and the bootstrap script

Before the run add completion to script to anywhere on your `.bashrc` or `.bash_profile`:

```bash
# completion for dotfiles bootstrap
function __bootsrap_comp() {
    local cur

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}

    case "$cur" in
        *)
            COMPREPLY=( $(compgen -W '-h --help -f --force --prefix=' -- $cur) );;
    esac

    return $SUCCESS
}
complete -F __bootsrap_comp -o filenames ./bootstrap.sh
```

Clone the git repos wherever your want and run the bootstrap script. It will
pull in the latest changes and copy the files to your home directory.

```bash
git clone https://github.com/vitalk/dotfiles.git && cd dotfiles && ./bootstrap.sh
```

The bootstrap script has some options, run for details

```bash
./bootstrap.sh --help
```

To update go to `dotfiles` dir and run this script again

```bash
./bootstrap.sh --force
```

## Custom hooks

To add a few custom hooks, which executed along with the other files, simple
add it to `~/.bash/hooks`. Use this file for commands you don't want to commit
to a public repository.

## Thanks to…

* Mathias Bynens and his [amazing dotfiles](https://github.com/mathiasbynens/dotfiles)
* Jan Moesen for his [tilde repository](https://github.com/janmoesen/tilde)

Anyone missed? [Get in touch](mailto:vital.kudzelka@gmail.com)

## Copyright

Copyright © 2012 Vital Kudzelka.

The scripts shall be used for Good, not Evil.
