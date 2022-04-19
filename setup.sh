#!/bin/bash

set -e

show_help () {
  echo "---Usage: sudo bash $0"
}

check_permissions () {
  if [[ $EUID -ne 0 ]]; then
     echo "---Run with root privileges"
     show_help
     exit
  fi
}

setup () {
  echo "---Setup started..."

  # docker-cleanup
  sudo wget -q -P /usr/local/bin/ https://raw.githubusercontent.com/thanospan/scripts/main/docker-cleanup/docker-cleanup.sh
  sudo chmod +x /usr/local/bin/docker-cleanup.sh

  # laptop-lid
  sudo wget -q -P /usr/local/bin/ https://raw.githubusercontent.com/thanospan/scripts/main/laptop-lid/laptop-lid.sh
  sudo chmod +x /usr/local/bin/laptop-lid.sh

  # night-light
  sudo wget -q -P /usr/local/bin/ https://raw.githubusercontent.com/thanospan/scripts/main/night-light/night-light.sh
  sudo chmod +x /usr/local/bin/night-light.sh

  # upatras-vpn
  sudo wget -q -P /usr/local/bin/ https://raw.githubusercontent.com/thanospan/scripts/main/upatras-vpn/upatras-vpn.sh
  sudo chmod +x /usr/local/bin/upatras-vpn.sh

  # vga2hdmi
  sudo wget -q -P /usr/local/bin/ https://raw.githubusercontent.com/thanospan/scripts/main/vga2hdmi/vga2hdmi.sh
  sudo chmod +x /usr/local/bin/vga2hdmi.sh

  echo "---Done!"
}

main () {
  check_permissions
  setup
}

main
