# Aliases
alias ..="cd .."
alias get=git
alias got=git
alias g=git
alias v=vim
alias sv="sudo vim"
alias vi=vim
alias diff='diff -u'
alias grep='grep --color=auto'
alias gb="setxkbmap gb && echo 'Set keyboard to gb'"
alias us="setxkbmap us && echo 'Set keyboard to us'"
alias de="setxkbmap de && echo 'Set keyboard to de'"
alias fix_samba="umount -a -t cifs -l && echo 'Unmounted all CIFS shares'"
alias editor=$EDITOR
alias halp="cat ~/.halp | shuf -n 1"
alias addhalp="cat >> ~/.halp"
alias argh="echo argh"
alias bashrc="shrc bash && source ~/.bashrc"
alias zshrc="shrc zsh && source ~/.zshrc"

for a in {0..10}; do
	alias awk$a="awk '{print \$$a}'"
done

function hexdiff {
	cmp -l $1 $2 | gawk '{printf "%08X %02X %02X\n", $1, strtonum(0$2), strtonum(0$3)}'
}

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
	screen -h 10240 -dmS $session bash -c "cd $dir; PRE='(screen) ' bash"
	echo "Created session: $session"
}

function smcup {
	if [ $1 == "-p" ]; then
		P=1
		shift
	fi

	tput smcup
	clear
	$@
	if [[ $P ]];
		then read -p "Press RETURN to exit";
	fi;
	tput rmcup
};
