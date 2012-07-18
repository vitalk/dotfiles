#!/bin/bash

# load bash aliases, functions, etc
for file in ~/.bash/{prompt,exports,aliases,functions,hooks}; do
    [ -r "$file" ] && source "$file"
done
unset file

# enable git completion if possible
[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[[ -e "$HOME/.ssh/config" ]] && complete -o bashdefault -o default -o nospace -W "$(cat ~/.ssh/config | grep "^Host" | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh rsync
