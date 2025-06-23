#!/bin/bash

reset="\033[0m"
bold="\033[1m"
bold_yellow="\033[1;33m"
bold_red="\033[1;31m"
bold_blue="\033[1;34m"
bold_cyan="\033[1;36m"
yellow="\033[33m"
red="\033[31m"
blue="\033[34m"
cyan="\033[36m"
faint="\033[2m"

printpath() {
    for (( i=1; i<=$#; i++ )); do
        if [[ $i -eq $# ]]; then
            echo -en "${bold_yellow}${!i}${reset}"
        else
            echo -en "${blue}${!i}${reset} -> "
        fi
    done
}

echo "There are a few more preferences you need to import."
echo -e "==> Run $bold_cyan./import.sh$reset to import them into your system."

echo
echo "There are some System Profiles you need to import too."
echo -e "==> 1. Run ${bold_cyan}open ../mobileconfigs${reset} to open the directory containing profiles."
echo -e "==> 2. Then ${bold}double-click on all of the profiles${reset} to install them. Click OK to any prompts that appear."
echo -n "==> 3. Finally, go to "; printpath "System Settings" "Genreal" "Device Management" "Downloaded" "Double-click on the profiles that have a warning sign below" "Install... (lower left corner)"; echo

echo
echo -e "There are a few more settings that I am not able to change. ${bold}Go ahead and change them manually${reset}:"
echo -n "==> 1: "; printpath "System Settings" "Wi-Fi" "Ask to join networks / Ask to join hotspots" "OFF"; echo " (it's annoying)"
echo -n "==> 2: "; printpath "System Settings" "General" "Software Update" "Automatic Updates" "i" "Turn Everything OFF"; echo " (I control when I want updates, not macOS)"
echo -n "==> 3: "; printpath "System Settings" "Displays" "Advanced" "Show resolution as list" "ON"; echo " (better control)"
echo -n "==> 4: "; printpath "System Settings" "Soptlight" "Only keep Applications, deselect everything"; echo " (we will use Alfred)"
echo -n "==> 5: "; printpath "System Settings" "Notifications" "Allow notifications when the display is sleeping" "OFF"; echo " (avoid constantly waking screen)"
echo -n "==> 6: "; printpath "System Settings" "Notifications" "Allow notifications when the screen is locked" "OFF"; echo " (Macs are not as personal as an iPhone, avoid leaking information when you are away)"
echo -n "==> 7: "; printpath "System Settings" "Notifications" "Allow notifications when mirroring or sharing the display" "OFF"; echo " (you don't want notifications to show up on a projector or TV)"
echo -n "==> 8: "; printpath "System Settings" "Privacy & Security" "(Scroll to the bottom)" "Allow applications from" "Anywhere"; echo " (do not let macOS decide what is safe or not, you are the one who decides)"
