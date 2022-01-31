# Environment Variables
export PATH=~/.local/bin:$PATH
export PATH=/var/lib/snapd/snap/bin:$PATH
export EDITOR=vim
export BROWSER=$HOME/.local/bin/surf
export GOPATH=~/.gopath
export PATH=$GOPATH/bin:/opt/google-cloud-sdk/platform/google_appengine/:$PATH
export PATH=$HOME/.local/scripts:$PATH
export shell=$(sh -c 'ps -p $$ -o ppid=' | xargs ps -o comm= -p)
export XDG_CONFIG_HOME="$HOME/.config"
export CHARM_HOST=$(cat ~/.charm_host)

# Add some colour to LESS/MAN pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;42;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'

export RANGER_LOAD_DEFAULT_RC=false

# Always use 32 bit wine prefix
export WINEPREFIX="$HOME/.wine32"
export WINEARCH=win32

export PATH=$PATH:~/.cargo/bin
