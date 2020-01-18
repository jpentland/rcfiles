#!/bin/bash
CFGDIR=configs
FORCE=$1; shift

function delete_and_link {
	SOURCE=$1
	DEST=$2
	mkdir -p $(dirname $HOME/$DEST)
	rm -ir $FORCE "$HOME/$DEST"
	ln -s "$PWD/$CFGDIR/$SOURCE" "$HOME/$DEST"
}

if [ " $FORCE" != " -f" ]; then
	echo "Note: Use -f to force deletion of source files"
fi

# Update Submodules
git submodule init
git submodule update

# Update vim plugins
delete_and_link "vim"			".vim"
delete_and_link "vimrc"			".vimrc"
vim +PluginInstall +qall
vim +PluginClean +qall

# General Files Source filename		# Destination filebane (relative to $HOME)
delete_and_link "bashrc"		".bashrc"
delete_and_link "zshrc"         ".zshrc"
delete_and_link "xmonad.hs"		".xmonad/xmonad.hs"
delete_and_link "startup.sh"		".xmonad/startup.sh"
delete_and_link "xmobarrc"		".xmobarrc"
delete_and_link "halp"			".halp"
delete_and_link "shrc.d"		".shrc.d"
delete_and_link "gitconfig"		".gitconfig"
delete_and_link "trayer.conf"		".trayer.conf"
delete_and_link "Xresources"		".Xresources"
delete_and_link "redshift.conf"		".config/redshift.conf"
delete_and_link "ranger"		".config/ranger"
delete_and_link "../scripts"       ".local/scripts"
delete_and_link "starship.toml" ".config/starship.toml"
delete_and_link "picom.conf"	".config/picom.conf"
delete_and_link "onionbrowse.pac"	"onionbrowse.pac"
delete_and_link "xmobar"	".local/xmobar"
delete_and_link "statnot"	".config/statnot"
delete_and_link "profile"	".profile"
delete_and_link "profile"	".xprofile"
delete_and_link "script.js"	".surf/script.js"
delete_and_link "styles"	".surf/styles"
delete_and_link "applications"	".local/share/applications"
delete_and_link "surf"	".local/lib/surf"
delete_and_link "dzen2"	".local/dzen2"
delete_and_link "sxhkdrc"	".config/sxhkd/sxhkdrc"
