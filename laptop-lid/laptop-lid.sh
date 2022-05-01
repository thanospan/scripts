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
  echo "Usage: sudo $filename [status|poweroff|suspend|lock|ignore|help]"
}

show_status () {
  sed -n '/HandleLidSwitch=/'p $config_file
}

check_permissions () {
  if [[ $EUID -ne 0 ]]; then
     echo "Run with root privileges"
     show_help
     exit
  fi
}

check_file () {
  if [[ ! -f "$1" ]]; then
    echo "Error: $1 not found"
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
      sed -i 's/.*HandleLidSwitch=.*/HandleLidSwitch=poweroff/' $config_file
      show_status
      restart
      ;;
    lock)
      sed -i 's/.*HandleLidSwitch=.*/HandleLidSwitch=lock/' $config_file
      show_status
      restart
      ;;
    suspend)
      sed -i 's/.*HandleLidSwitch=.*/HandleLidSwitch=suspend/' $config_file
      show_status
      restart
      ;;
    ignore)
      sed -i 's/.*HandleLidSwitch=.*/HandleLidSwitch=ignore/' $config_file
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
  filename=$(basename $0)
  config_file="/etc/systemd/logind.conf"

  check_permissions
  check_file $config_file
  parse_options "$@"
}

main "$@"
