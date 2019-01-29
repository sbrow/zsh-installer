#!/bin/bash
# BEGIN FRONTMATTER

# A Simple y/n prompt.
# Takes a message parameter.
# Returns 1 for yes, 0 for no.
function prompt() {
    local bool
    while [[ -z $bool ]]; do
        read -r -p "$1 [Y/n] " input
    
        case $input in
        [yY][eE][sS]|[yY])
            bool=1;;
        [nN][oO]|[nN])
            bool=0;;
        *)
            echo "Invalid input...";;
        esac
    done
    echo $bool
    return $bool
}

# Whether or not this is a dry run.
DRY=false

# Interpret options
while getopts d name; do
    case $name in
        d)
            DRY=true;;
        *)
            echo "Invalid args";;
    esac
done

if [[ $DRY = true ]]; then
    ZSHENV="./.example.zshenv";
    ZPROFILE="./.example.zprofile"
else
    ZSHENV="~/.zshenv"
    ZPROFILE="./.zprofile"
fi

# END FRONTMATTER

echo "" > $ZSHENV
echo "" > $ZPROFILE

# Use vim as standard editor
echo "Enabling vim as default editor..."
echo "EDITOR=vim" >> $ZSHENV

if [[ $(prompt "Allow gpg keys to be used for ssh?") = 1 ]]; then
    echo 'export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent /bye' >> $ZPROFILE
fi

echo "zsh configured!"