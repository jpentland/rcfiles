#!/bin/bash
CFGDIR=configs
FORCE=$1

function delete_and_link {
	SOURCE=$1
	DEST=$2
	mkdir -p $(dirname $HOME/$DEST)
	rm -i $FORCE "$HOME/$DEST"
	ln -s "$PWD/$CFGDIR/$SOURCE" "$HOME/$DEST"
}

if [ " $FORCE" != " -f" ]; then
	echo "Note: Use -f to force deletion of source files"
fi

#		Source filename		# Destination filebane (relative to $HOME)
delete_and_link "bashrc"		".bashrc"
delete_and_link "vimrc"			".vimrc"
delete_and_link "xmonad.hs"		".xmonad/xmonad.hs"
delete_and_link "xmobarrc"		".xmobarrc"
delete_and_link "halp"			".halp"
delete_and_link "bashrc.d"		".bashrc.d"
delete_and_link "gitconfig"		".gitconfig"
delete_and_link "vim"			".vim"
