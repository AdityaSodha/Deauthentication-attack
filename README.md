# Deauth-Simulator

## Description
This script automates the process of performing a deauthentication attack using `aircrack-ng`. It provides a user-friendly interface, automatically detects wireless interfaces, enables monitor mode, captures handshake data, and performs deauthentication attacks in a controlled manner.


## Features
- Automatically detects the wireless interface.
- Enables and disables monitor mode as required.
- Captures handshake data for a specified WiFi network.
- Performs deauthentication attacks with user confirmation.
- Safe cleanup to restore network settings after execution.
- Clean and readable script with highlighted comments for easy understanding.
- **Check `commands.txt` for manual commands**

---

## Prerequisites
- **Operating System:** Linux (Tested on Kali Linux and Ubuntu).
- **Dependencies:** `aircrack-ng`, `gnome-terminal`.
- **Permissions:** Run the script with root privileges (`sudo`).

---

## Installation
1. Clone this repository or download the script:
   ```bash
   git clone https://github.com/Adityasinh-Sodha/deauth-simulator.git
   cd deauth-simulator
   ````
   
2. Give the permissions and execute:
    ```bash
    chmod +x deauth.sh
    ./deauth
    ```
## usage
- The script will detect your wireless interface and enable monitor mode.
- The script shows all WIFI networks in your area 
- Select your WIFI network and Use Ctrl+C to stop airodump-ng
- proceed to enter the Channel (CH) and BSSID.
- A new terminal will open to capture handshake data and **DO NOT CLOSE IT**
- Confirm the warning message to proceed with the deauthentication attack.

---
![deauth](https://github.com/user-attachments/assets/7acb32a3-3766-44f9-915e-316f1347d803)
---


## Warning
**This script is for educational purposes only.**
- Only use this tool on networks you own or have explicit permission to test.
- Unauthorized use on public or private networks is illegal and unethical.
- The creators of this script are not responsible for any misuse or damage caused.

## Author
Developed by **Adityasinh**.
