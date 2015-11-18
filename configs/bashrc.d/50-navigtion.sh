# Better directory navigation
alias b="popd > /dev/null"
alias cd="cdpushd > /dev/null"

function cdpushd()
{
    if [ -n "$1" ]
    then
        pushd "$*"
    else
        if [ "$(pwd)" != "$HOME" ]
        then
            pushd ~
        fi
    fi
}

