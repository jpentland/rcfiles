# Allow b to go back
alias b="popd > /dev/null"
alias cd="cdpushd > /dev/null"
alias ..="cd .."
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

function cdpushd()
{
    if [ -n "$1" ]
    then
        pushd "$*"
        ls
    else
        if [ "$(pwd)" != "$HOME" ]
        then
            pushd ~
            ls
        fi
    fi
}

