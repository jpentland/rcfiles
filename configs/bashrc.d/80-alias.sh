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
alias fix_samba="umount -a -t cifs -l && echo 'Unmounted all CIFS shares'"
alias vi=vim
alias editor=$EDITOR
alias term="bash -c 'konsole &'"

function noerr {
	$@ 2> /dev/null
}
