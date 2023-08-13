#!/bin/bash -i

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
    USERNAME=`cat /etc/passwd | tail -n1 | cut -d":" -f1`
    echo "Updating repository and upgrading system"
    sleep 1
    apt update && apt upgrade
    echo "Install curl, wget, zsh sudo vim"
    sleep 1
    apt install curl wget zsh sudo vim python3-pip bat -y
    pip install thefuck
    sleep 1
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh  > /home/$USERNAME/installomz.sh
    # Found /home/admini/.zshrc. Backing up to /home/admini/.zshrc.pre-oh-my-zsh
    echo "&& mv /home/'$USERNAME'/.zshrc.pre-oh-my-zsh /home/'$USERNAME'/.zshrc" >> /home/$USERNAME/installomz.sh
    chmod u+x /home/$USERNAME/installomz.sh
    cp ../shared/.vimrc /home/$USERNAME/.vimrc
    cp ../macos/.zshrc /home/$USERNAME/.zshrc
    usermod -aG sudo $USERNAME
    echo "Added '$USERNAME' to sudo group"
    usermod -s /usr/bin/zsh $USERNAME
    echo "Set zsh as default for '$USERNAME'"
    echo ""
    echo "Setup is almost complete!"
    echo "Log in to default non-priviled user and run ./installomz.sh"
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
