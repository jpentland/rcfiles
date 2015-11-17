#!/bin/sh

function delete_and_link {
	SOURCE=$1
	DEST=$2
	rm -i "$HOME/$DEST"
	ln -s "$PWD/$SOURCE" "$HOME/$DEST"
}

delete_and_link "bashrc"	".bashrc"
delete_and_link "vimrc"		".vimrc"
delete_and_link "xmonad.hs"	".xmonad/xmonad.hs"
delete_and_link "xmobarrc"	".xmobarrc"
