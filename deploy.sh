#!/bin/bash
CFGDIR=configs
SCRIPTDIR=scripts
FORCE=$1
BIN=$HOME/.local/bin

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
delete_and_link "startup.sh"		".xmonad/startup.sh"
delete_and_link "mediacontrol.sh"	".xmonad/mediacontrol.sh"
delete_and_link "xmobarrc"		".xmobarrc"
delete_and_link "halp"			".halp"
delete_and_link "bashrc.d"		".bashrc.d"
delete_and_link "gitconfig"		".gitconfig"
delete_and_link "konsolerc"		".config/konsolerc"
delete_and_link "vim"			".vim"
delete_and_link "muttrc"		".muttrc"
delete_and_link "trayer.conf"		".trayer.conf"
delete_and_link "Xresources"		".Xresources"
delete_and_link "redshift.conf"		".config/redshift.conf"


# Link all scripts to local bin dir
mkdir -p $BIN/$s
for s in $(ls -1 $SCRIPTDIR); do
	rm -i $FORCE "$BIN/$s"
	ln -s "$PWD/$SCRIPTDIR/$s" "$BIN/$s"
done
