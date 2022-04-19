#!/bin/bash

set -e

show_help () {
  echo "Usage: sudo $filename"
}

check_permissions () {
  if [[ $EUID -ne 0 ]]; then
     echo "---Run with root privileges"
     show_help
     exit
  fi
}

get_username () {
  read -p "Username: " USERNAME
}

get_password () {
  read -s -p "Password: " PASSWORD
  echo
}

save_cookies () {
  echo "---Saving cookies.txt..."
  curl -s -o /dev/null -d "username=$USERNAME" -d "password=$PASSWORD" -c cookies.txt "https://mussa.upnet.gr/user/"
  echo "---cookies.txt saved!"
}

download_file () {
  echo "---Downloading UPatras.ovpn..."
  curl -s -b cookies.txt "https://mussa.upnet.gr/user/index.php?action=downloadFile&fn=ovpncnf" -o /etc/openvpn/UPatras.ovpn
  echo "---UPatras.ovpn downloaded!"
}

delete_cookies () {
  echo "---Deleting cookies.txt..."
  rm cookies.txt
  echo "---cookies.txt deleted!"
}

connect () {
  echo "---Connecting to UPatras VPN..."
  openvpn --config /etc/openvpn/UPatras.ovpn --auth-user-pass <(echo -e $USERNAME"\n"$PASSWORD)
}

main () {
  filename=$(basename $0)

  check_permissions
  get_username
  get_password
  if [[ ! -f /etc/openvpn/UPatras.ovpn ]]; then
    save_cookies
    download_file
    delete_cookies
  fi
  connect
}

main "$@"
