#!/bin/bash

PROGRAM_NAME="drall"

DEFAULT_PREFIX="/usr/share"
BIN_PATH="/usr/local/bin"
SOURCE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SCRIPT_ASSUME_YES=""

PREFIX="$DEFAULT_PREFIX"
INSTALL_DIR="$PREFIX/$PROGRAM_NAME"

usage() {
	echo "
Usage: $0

Options:
    -y Assume yes for all questions"

}

if [ "$1" = "--help" ]; then
	usage
	exit 1
fi

while getopts ":y" opt; do
	case "$opt" in
		y) SCRIPT_ASSUME_YES="1"
		shift
		;;
	esac
done

if [ ! -w "$PREFIX" ]; then
	echo "You cannot write to $INSTALL_DIR, aborting."
	exit 1
fi

if [ -z "$SCRIPT_ASSUME_YES" ]; then
	read -p "Install $PROGRAM_NAME to $INSTALL_DIR (y/n)? " -n 1 -r
	echo ""
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo "Aborting installation."
		exit 1
	fi
fi


if [ -d "$INSTALL_DIR" ]; then
	echo "Previous installation detected."
	if [ -z "$SCRIPT_ASSUME_YES" ]; then
		read -p "Replace $INSTALL_DIR (y/n)? " -n 1 -r
		echo ""
		if [[ ! $REPLY =~ ^[Yy]$ ]]; then
			echo "Aborting installation."
			exit 1
		fi
	fi
fi

# install amoffat/sh
python -c "import sh" 2>/dev/null || {
	pip install sh
}

# install popstas/server-scripts
if [ ! -f /etc/server-scripts.conf ]; then
	git clone https://github.com/popstas/server-scripts.git /usr/local/src/server-scripts
	/usr/local/src/server-scripts/install.sh -y
fi

rsync -a "$SOURCE_DIR/" "$INSTALL_DIR" || {
	echo "Sync files to $INSTALL_DIR failed."
	exit 1
}

mkdir -p "$INSTALL_DIR/match-tests"

chmod +x "$INSTALL_DIR"/bin/*

if [ -w "$BIN_PATH" ]; then
	# TODO: ln -s -f too danger, it rewrites files!
	find "$INSTALL_DIR"/bin -type f -exec ln -s {} "$BIN_PATH" \; 2>/dev/null
fi

echo "Installed $PROGRAM_NAME to $INSTALL_DIR."
