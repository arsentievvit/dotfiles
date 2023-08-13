#!/bin/bash

# dotfiles-setup
# by arsentievvit
# for me only 
# ver 0.1

set -e

# Help function

Help()
{
    # Display help

    echo "This script is used to copy dotfiles from repo to"
    echo "their respective place and install software that "
    echo "is needed for operation"
    echo ""
    echo "Usage:"
    echo "setup.sh [-i][-z][-v]"
    echo "options:"
    echo "i     install software and copy files for the current distribution"
    echo "z     copy zshrc file to user homedir"
    echo "v     copy vimrc file to user homedir"
    echo ""

}

Installsoftware()
{
    PS3="Select your distribution: "
    echo $PS3
    select distrib in Debian-based RHEL-based MacOS Exit

    do
        case $distrib in
            "Debian-based")
                echo "Using APT"
                DebianInstall
                exit;;
            "RHEL-based")
                echo "Using dnf"
                RHELInstall
                exit;;
            "MacOS")
                echo "Searching for brew"
                MacosInstall
                exit;;
            "Exit")
                exit;;
            *)
                echo "Wrong selection"
                Installsoftware
                exit;;
        esac
    done
}

DebianInstall()
{
    echo "Updating repository and upgrading system"
    sleep 1
    sudo apt update && sudo apt upgrade
    echo "Install curl, wget, getting omz"
    sleep 1
    sudo apt install curl wget zsh
    sleep 1
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    cp ../shared/.vimrc ~/.vimrc
    cp ../macos/.zshrc ~/.zshrc
    
}

while getopts ":hivz:" option; do
    case $option in
        h) # display Help
        Help
        exit;;
        i) # install software
        Installsoftware
        exit;;
        z) # copy zshrc
        Zshcopy
        exit;;
        v) # copy vimrc
        Vimcopy
        exit;;
        \?) # Invalid
        echo "Invalid option"
        exit;;
    esac
done

if [[ $# -eq 0 ]] ; then
    Help
    exit 0
fi