#!/bin/bash

function showOptions() {
    echo "-d,  Directory to install all binaries within."
    echo "-h,  Show this help message."
    echo "Usage: $(basename $0) [Options] [Binary(ies) to install]"
    echo "Example: $(basename $0) ~/Downloads/mount_efi.sh"
}

function installBinary() {
    fileName=$(basename $1)
    echo Installing $fileName to /usr/bin
    sudo rm -Rf /usr/bin/$fileName
    sudo cp -Rf $1 /usr/bin
}

while getopts d:h option; do
    case $option in
        d)
            directory=$OPTARG
        ;;
        h)
            showOptions
            exit 0
        ;;
    esac
done

shift $((OPTIND-1))

if [[ $directory ]]; then
    binaries=$(find $directory -type f -perm -u+x -not -path \*.kext/* -not -path \*.app/* -not -path \*/Debug/*)
elif [[ $@ ]]; then
    binaries=$@
else
    showOptions
    exit 1
fi

for bin in $binaries; do
    if [[ ! -e $bin ]]; then
        echo "Could not find $bin. Make sure the path is correct."
        continue
    fi
    installBinary $bin
done
