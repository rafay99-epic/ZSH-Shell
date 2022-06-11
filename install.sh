#!/bin/bash

#Location for Paru
PARU=/usr/bin/paru

# This will check which package manager your are running 
declare -A osInfo;
osInfo[/etc/debian_version]="apt-get"
osInfo[/etc/arch-release]="pacman"

#to find the which Os yo are running
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];
    then
         package_manager=${osInfo[$f]}
    fi
done


function good-bye() 
{
    echo -ne "
-------------------------------------------------------------------------
        Thank Your using our Script!!
        Have a Good Day 🙂😊

        Regards  Abdul Rafay
-------------------------------------------------------------------------
"
}

function welcome-Message() 
{
    echo -ne "
-------------------------------------------------------------------------
            Welcome to Kitty Terminal & ZSH Config

            Author: Abdul Rafay
            Email: 99marafay@gmail.com
            GitHub: rafay99-epic
-------------------------------------------------------------------------
"
}

function non-root() 
{
    if [ "$USER" = root ]; then
        echo -ne "
-------------------------------------------------------------------------
          This script shouldn't be run as root. ☹️🙁

          Run script like this:-  ./install.sh
-------------------------------------------------------------------------
"
        exit 1
    fi
}

function os()
{
    if [[ "$package_manager" == "pacman" ]];
    then
        arch
    elif [[ "$package_manager" == "apt-get" ]];
    then
        debian
    else
        echo 'Error Occured: ${package_manager}'
        exit 0
    fi
}

function starship_promote()
{ 
    echo -ne "
-------------------------------------------------------------------------
           Installing Startship Promote
-------------------------------------------------------------------------
"  
    curl -sS https://starship.rs/install.sh | sh
}

# Installing of fm6000
function fm6000()
{
    echo -ne "
-------------------------------------------------------------------------
           Installing FM6000
-------------------------------------------------------------------------
"
    sh -c "$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)"
}

# Customizing Startship Promote 
function starship_promote_customize()
{
    echo -ne "
-------------------------------------------------------------------------
           --- Customizing Startship Promote ---

Do you want to Customize the Starship prmote??
Enter your Choice: 
                 Yes to Customize  
                 No  to Default Look 
-------------------------------------------------------------------------
"
    read -p "--- Enter your Choice ---: " user_choice

    if [[ "$user_choice" == "yes" || "$user_choice" == "Yes" || "$user_choice" == "YES" || "$user_choice" == "yEs" || "$user_choice" == "yeS"  ]];
    then
        echo "Customizing Startship Promote: "
        cp -r starship.toml ~/.config
        echo "Customizing is Done"   
    elif [[ "$user_choice" == "no" || "$user_choice" == "No" || "$user_choice" == "nO" || "$user_choice" == "NO" ]];
    then     
        echo "There is no customizing to the promote.."    
    fi
}
function config_zsh()
{
    echo -ne "
-------------------------------------------------------------------------
            Placing the Dot Files for ZSH
-------------------------------------------------------------------------
"
    # Placing the files
    cp -r .zshrc   ~/
}
function default_Shell()
{
    echo -ne "
-------------------------------------------------------------------------
           Changing Default Shell to ZSH
           User Password is Required
-------------------------------------------------------------------------
"
    chsh -s /bin/zsh
}

function arch()
{
    echo -ne "
-------------------------------------------------------------------------
           Arch System is Detected....
-------------------------------------------------------------------------
"
    paru-install
    arch_app
    starship_promote
    starship_promote_customize
    fm6000
    config_zsh
    default_Shell

}
function paru-install()
{
    if [ ! -e "$PARU" ]; 
        then
            echo -ne "
-------------------------------------------------------------------------
           Installing Rust
-------------------------------------------------------------------------
"
            sudo pacman -S rust --noconfirm --needed 
            
            echo -ne "
-------------------------------------------------------------------------
           Installing Base System for ARU-Helper
-------------------------------------------------------------------------
"
            sudo pacman -S base-devel --noconfirm -needed
           
            echo -ne "
-------------------------------------------------------------------------
           Installing Paru
-------------------------------------------------------------------------
"
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si
            cd ../
        else
            echo -ne "
-------------------------------------------------------------------------
           Paru is already installed...
-------------------------------------------------------------------------
"
        fi    
}
function arch_app()
{    
    echo -ne "
-------------------------------------------------------------------------
           Installing ZSH Shell
-------------------------------------------------------------------------
"
    sudo pacman -S zsh --noconfirm --needed

    echo -ne "
-------------------------------------------------------------------------
           Installing LSD
-------------------------------------------------------------------------
"
    sudo pacman -S lsd --noconfirm --needed

    echo -ne "
-------------------------------------------------------------------------
           Installing  Powerline-font
-------------------------------------------------------------------------
"
    # There is a confit in font packages that why remoing ttf-hack font 
    paru -R ttf-hack --noconfirm --needed
    # Installing powerline font
    paru -S powerline-fonts-git --noconfirm --needed

    echo -ne "
-------------------------------------------------------------------------
           Installing  Awesome-font
-------------------------------------------------------------------------
"   
    # Installing ttf-awesome fonts
    paru -S ttf-font-awesome --noconfirm --needed

    echo -ne "
-------------------------------------------------------------------------
           Installing  ZSH Tools
            1. ZSH syntx highlighting
            2. Autojump
            3. ZSH Auto Suggestestion
-------------------------------------------------------------------------
"
    paru  -S zsh-syntax-highlighting autojump zsh-autosuggestions --noconfirm --needed
}



function debian()
{
    echo -ne "
-------------------------------------------------------------------------
        Debian System is Detected....
-------------------------------------------------------------------------
"
    debain_app
    starship_promote
    starship_promote_customize
    fm6000
    config_zsh
    default_Shell
}
function debain_app()
{
    echo -ne "
-------------------------------------------------------------------------
           Installing ZSH Shell
-------------------------------------------------------------------------
"
    sudo apt-get install zsh -y

    echo -ne "
-------------------------------------------------------------------------
           Installing LSD
-------------------------------------------------------------------------
"
    sudo dpkg -i lsd.deb

    echo -ne "
-------------------------------------------------------------------------
           Installing Powerline  Fonts
-------------------------------------------------------------------------
"
    sudo apt-get install -y fonts-powerline    

    echo -ne "
-------------------------------------------------------------------------
           Installing Awesome Fonts
-------------------------------------------------------------------------
"
    sudo apt-get install -y fonts-font-awesome

    echo -ne "
-------------------------------------------------------------------------
           Installing  ZSH Tools
            1. ZSH syntx highlighting
            2. Autojump
            3. ZSH Auto Suggestestion
-------------------------------------------------------------------------
"
    sudo apt install zsh-syntax-highlighting autojump zsh-autosuggestions -y

}

function runner()
{
    welcome-Message

    non-root

    os

    good-bye
}
runner