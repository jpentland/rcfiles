# Aliases
alias icanhas="sudo apt-get install"
alias donotwant="sudo apt-get remove"
alias ..="cd .."
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias foscm=/home/jpe/apps/foscm/foscm
alias halp="cat ~/.halp | shuf -n 1"
alias addhalp="cat >> ~/.halp"
alias get=git
alias got=git
alias g=git
alias v=vim
alias updateall='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade'
alias diff='diff -u'
alias grep='grep --color=auto'
alias curl-os="curl --cert $CD/cert.crt  --key $CD/key.pem --cacert $CD/cacert.crt"
alias ccolor="highlight --syntax c -O xterm256 | less -R"
alias checkcommit="git show | ~/script/checkpatch.pl --notree --no-signoff --strict --subjective -"
alias checkkcommit="git show | ~/script/checkpatch.pl --no-signoff --strict --subjective -"
alias cat=lolcat
