#!/bin/bash

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function link_to_home {
	ln -sf $DOTFILES_DIR/$1 $HOME/$1
	echo "linked $1"
}

link_to_home ".bash_profile"