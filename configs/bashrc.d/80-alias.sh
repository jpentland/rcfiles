# Aliases
alias icanhas="sudo apt-get install"
alias donotwant="sudo apt-get remove"
alias ..="cd .."
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias get=git
alias got=git
alias g=git
alias v=vim
alias updateall='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade'
alias diff='diff -u'
alias grep='grep --color=auto'
alias checkcommit="git show | ~/script/checkpatch.pl --notree --no-signoff --strict --subjective -"
alias checkkcommit="git show | ~/script/checkpatch.pl --no-signoff --strict --subjective -"
alias gb="setxkbmap gb && echo 'Set keyboard to gb'"
alias us="setxkbmap us && echo 'Set keyboard to us'"
alias de="setxkbmap de && echo 'Set keyboard to de'"
alias gvim="gvim --remote-tab-silent"

function ban {

	sudo su -c "echo 0.0.0.0 $1 | tee -a /etc/hosts"
}
