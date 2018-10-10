# Aliases
alias ..="cd .."
alias get=git
alias got=git
alias g=git
alias v=vim
alias diff='diff -u'
alias grep='grep --color=auto'
alias checkcommit="git show | ~/script/checkpatch.pl --notree --no-signoff --strict --subjective -"
alias checkkcommit="git show | ~/script/checkpatch.pl --no-signoff --strict --subjective -"
alias gb="setxkbmap gb && echo 'Set keyboard to gb'"
alias us="setxkbmap us && echo 'Set keyboard to us'"
alias de="setxkbmap de && echo 'Set keyboard to de'"
alias fix_samba="umount -a -t cifs -l && echo 'Unmounted all CIFS shares'"
alias vi=vim
alias editor=$EDITOR
alias term="bash -c 'konsole &'"
alias sm=screenmenu

# Open a file in a vim screen session
function svim {
	file=$(basename $1)
	dir=$(dirname $1 | xargs readlink -f | xargs basename)
	screen -Rd vim.$dir.$file vim $1
}


function noerr {
	$@ 2> /dev/null
}

function sdir  {
	dir=$1
	if [[ ! $dir ]]; then
		dir=$PWD
	fi

	session=dir.$(echo $dir | xargs readlink -f | xargs basename)
	screen -dmS $session bash -c "cd $dir; PRE='(screen) ' bash"
	echo "Created session: $session"
}

