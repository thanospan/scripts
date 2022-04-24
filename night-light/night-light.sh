#!/bin/bash
export LC_NUMERIC=C

set -e

show_help () {
  echo "Usage: $filename [OPTIONS]"
  echo
  echo "Options:"
  echo "  --help"
  echo "  --status"
  echo "  --on"
  echo "  --off"
  echo "  --temp       Range: [1700, 4700]"
  echo "  --from       Range: [00:00, 23:59]"
  echo "  --to         Range: [00:00, 23:59]"
  echo
}

# https://www.oreilly.com/library/view/regular-expressions-cookbook/9781449327453/ch04s06.html
# HH:MM, 24-hour clock
validate_time () {
  if ! [[ $2 =~ ^(2[0-3]|[01]?[0-9]):([0-5]?[0-9])$ ]]; then
    echo "Error! Valid $1 range: [00:00, 23:59]"
  fi
}

validate_temp () {
  if ! [[ $2 =~ ^[0-9]+$ ]] || [[ $2 -lt 1700 ]] || [[ $2 -gt 4700 ]]; then
    echo "Error! Valid $1 range: [1700, 4700]"
  fi
}

time_to_decimal () {
  echo $(awk -F: '{printf "%.4f", ($1*60+$2)/60}' <<< $1)
}

decimal_to_time () {
  echo $(awk -F. '{printf "%.f:%.f", $1, $2*60*0.0001}' <<< $1)
}

show_status () {
  status=$(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled)
  if [[ "$status" = "true" ]]; then
    echo "Status: On"
  else
    echo "Status: Off"
  fi

  from=$(gsettings get org.gnome.settings-daemon.plugins.color night-light-schedule-from)
  from=$(printf "%0.4f\n" $from)
  from=$(decimal_to_time $from)
  echo "From: $from"

  to=$(gsettings get org.gnome.settings-daemon.plugins.color night-light-schedule-to)
  to=$(printf "%0.4f\n" $to)
  to=$(decimal_to_time $to)
  echo "To: $to"

  temp=$(gsettings get org.gnome.settings-daemon.plugins.color night-light-temperature)
  # Keep last word
  temp=${temp##* }
  echo "Temperature: $temp"
}

parse_options () {
  if [[ $# -eq 0 ]]; then
    echo "See '$filename --help'"
  fi
  while [[ $# -gt 0 ]]; do
    case $1 in
      --on)
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
        shift
        ;;
      --off)
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
        shift
        ;;
      --from)
        response=$(validate_time $1 $2)
        if [[ $response =~ "Error" ]]; then
          echo $response
        else
          decimal_hours=$(time_to_decimal $2)
          gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from $decimal_hours
        fi
        shift
        shift
        ;;
      --to)
        response=$(validate_time $1 $2)
        if [[ $response =~ "Error" ]]; then
          echo $response
        else
          decimal_hours=$(time_to_decimal $2)
          gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to $decimal_hours
        fi
        shift
        shift
        ;;
      --temp)
        response=$(validate_temp $1 $2)
        if [[ $response =~ "Error" ]]; then
          echo $response
        else
          gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature $2
        fi
        shift
        shift
        ;;
      --status)
        show_status
        shift
        ;;
      --help)
        show_help
        shift
        ;;
      *)
        echo "Option '$1' not found"
        echo "See '$filename --help'"
        echo
        shift
        ;;
    esac
  done
}

main () {
  filename=$(basename $0)

  parse_options "$@"
}

main "$@"
