# Aliases
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
alias vimrc="vim ~/.vimrc"
alias sctl="sudo systemctl"
alias jctl="journalctl"
alias bt="bluetoothctl"
alias wttr="curl wttr.in"
alias xmonadhs="$EDITOR ~/.xmonad/xmonad.hs"
alias startup="$EDITOR ~/.xmonad/startup.sh"
alias bspwmrc="$EDITOR ~/.config/bspwm/bspwmrc"
alias sxhkdrc="$EDITOR ~/.config/sxhkd/sxhkdrc"

function rcgui {
	pushd ~/rcfiles > /dev/null
	git gui
	popd > /dev/null
}

function install {
	choice=$(pacman -Sl | awk '{print $2}' | fzf)
	if ! [ -z $choice ]; then
		sudo pacman -S $choice
	fi
}

function remove {
	choice=$(pacman -Qs | sed -n 's/^local\/\([^ ]\+\) .*/\1/p' | fzf)
	if ! [ -z $choice ]; then
		sudo pacman -R $choice
	fi
}

for a in {0..10}; do
	alias awk$a="awk '{print \$$a}'"
done

function bashrc {
	shrc bash $@
	source ~/.bashrc
}

function zshrc {
	shrc zsh $@
	source ~/.zshrc
}

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

cconv() {
  wget -qO- "http://www.google.com/finance/converter?a=$1&from=$2&to=$3" #|  sed '/res/!d;s/<[^>]*>//g';
}

urlencode() {
  python -c "from urllib.parse import quote; print(quote('''$@''', safe=''))"
}

function homedirs {
  find $HOME -maxdepth 4 -type d -printf '%P\n' 2> /dev/null
}

function fuzzydirs {
  cd $(homedirs | grep -v '^\.' | fzf)
}

function fuzzyranger {
  ranger $(homedirs | grep -v '^\.' | fzf) < $TTY
}

function zshrcbind {
  zshrc < $TTY
}

zle -N fuzzydirs
zle -N fuzzyranger
zle -N zshrcbind
bindkey "^g" fuzzydirs
bindkey "^r" fuzzyranger
bindkey "^h" zshrcbind
