# With git branch support, print time of day

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
function proml {
    local BLUE="\[\033[0;34m\]"
    local RED="\[\033[0;31m\]"
    local LIGHT_RED="\[\033[1;31m\]"
    local GREEN="\[\033[0;32m\]"
    local LIGHT_GREEN="\[\033[1;32m\]"
    local WHITE="\[\033[1;37m\]"
    local LIGHT_GRAY="\[\033[0;37m\]"

    PS1="\u@\h:$RED [\$(date +'%H:%M')]$LIGHT_GRAY [\W]$GREEN \$(parse_git_branch) $LIGHT_GRAY\n--> "
    PS2='> '
    PS4='+ '
}
proml

