#!/bin/bash
CFGDIR=configs
FORCE=$1; shift
VIM_PLUG_SHA256=0d4dc422c3151ff651063b251933b3465714c5b9f3226faf0ca7f8b4a440a552
VIM_PLUG_INSTALL=$HOME/.vim/autoload/plug.vim
NVIM_PLUG_INSTALL=$HOME/.local/share/nvim/site/autoload

function delete_and_link {
	SOURCE=$1
	DEST=$2
	mkdir -p $(dirname $HOME/$DEST)
	rm -ir $FORCE "$HOME/$DEST"
	ln -s "$PWD/$CFGDIR/$SOURCE" "$HOME/$DEST"
}

function install_vim_plug {
    wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	sum=$(sha256sum plug.vim | awk '{print $1}')
	if [ "$sum" != "$VIM_PLUG_SHA256" ]; then
		while true; do
			read -p "WARNING: Vim plug sha256 does not match, install anyway? [y]es,[n]o,[v]iew > " answer
			case $answer in
				y)
					break
					;;
				n)
					return
					;;
				v)
					less plug.vim
					continue
			esac
		done
	fi

	set -x
	mkdir -p $VIM_PLUG_INSTALL
	mkdir -p $NVIM_PLUG_INSTALL
	cp plug.vim $VIM_PLUG_INSTALL
	cp plug.vim $NVIM_PLUG_INSTALL
	set +x
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
delete_and_link "nvim" ".config/nvim"
install_vim_plug
vim +PluginInstall +qall
vim +PluginClean +qall
nvim +PlugInstall

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
delete_and_link "bspwmrc"	".config/bspwm/bspwmrc"
delete_and_link "tmux.conf"	".tmux.conf"
