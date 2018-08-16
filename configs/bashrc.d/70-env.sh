# Environment Variables
export PATH=~/.local/bin:$PATH
export EDITOR=vim
export BROWSER=chromium-browser
export GOPATH=/home/jpe/.gopath
export PATH=$GOPATH/bin:/opt/google-cloud-sdk/platform/google_appengine/:$PATH
shopt -s histappend

# Add some colour to LESS/MAN pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m' 
export LESS_TERMCAP_so=$'\E[01;42;30m'
export LESS_TERMCAP_ue=$'\E[0mkkkk'
export LESS_TERMCAP_us=$'\E[01;36m'
