#!/bin/bash

set -e

restart () {
  read -p "Restart now? [y/n] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Restarting..."
    # systemctl restart systemd-logind.service
    shutdown -r now
  else
    echo "Restart to apply changes"
    exit
  fi
}

show_help () {
  echo "Usage: sudo $0 [status|poweroff|suspend|lock|ignore|help]"
}

show_status () {
  sed -n '/HandleLidSwitch=/'p /etc/systemd/logind.conf
}

check_permissions () {
  if [[ $EUID -ne 0 ]]; then
     echo "Run with root privileges"
     show_help
     exit
  fi
}

parse_options () {
  case "$@" in
    status)
      show_status
      exit
      ;;
    poweroff)
      sed -i 's/HandleLidSwitch=.*/HandleLidSwitch=poweroff/' /etc/systemd/logind.conf
      show_status
      restart
      ;;
    lock)
      sed -i 's/HandleLidSwitch=.*/HandleLidSwitch=lock/' /etc/systemd/logind.conf
      show_status
      restart
      ;;
    suspend)
      sed -i 's/HandleLidSwitch=.*/HandleLidSwitch=suspend/' /etc/systemd/logind.conf
      show_status
      restart
      ;;
    ignore)
      sed -i 's/HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
      show_status
      restart
      ;;
    help)
      show_help
      exit
      ;;
    *)
      echo "Option '$@' not found"
      show_help
      exit
      ;;
  esac
}

main () {
  check_permissions
  parse_options "$@"
}

main "$@"
