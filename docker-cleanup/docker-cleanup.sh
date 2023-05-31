#!/bin/bash

set -e

show_help () {
  echo "Usage: $filename [OPTIONS]"
  echo
  echo "Options:"
  echo "  --help"
  echo "  --filter, -f      Remove containers, volumes and networks based on filter"
  echo "  --all, -a         Remove all containers, volumes and networks"
  echo
}

check_dependencies () {
  echo
  echo "---Checking dependencies..."
  dependencies="docker"
  for dependency in $dependencies; do
    if [[ -z $(command -v $dependency) ]]; then
      echo "Command '$dependency' not found"
      exit
    fi
  done
  echo "---All dependencies are installed!"
  echo
}

show_warning () {
  read -p "---Remove Docker containers, volumes and networks? [y/n] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit
  fi
  echo
}

remove_containers () {
  echo "---Removing containers..."

  if [[ $# -eq 0 ]]; then
    CONTAINERS=$(docker container ls -aq)
  else
    CONTAINERS=$(docker container ls -aq -f $1)
  fi

  echo $CONTAINERS | xargs -r docker container rm -f
  echo "---Containers removed!"
  echo
}

remove_volumes () {
  echo "---Removing volumes..."

  if [[ $# -eq 0 ]]; then
    VOLUMES=$(docker volume ls -q)
  else
    VOLUMES=$(docker volume ls -q -f $1)
  fi

  echo $VOLUMES | xargs -r docker volume rm -f
  echo "---Volumes removed!"
  echo
}

remove_networks () {
  echo "---Removing networks..."

  if [[ $# -eq 0 ]]; then
    NETWORKS=$(docker network ls -q -f type=custom)
  else
    NETWORKS=$(docker network ls -q -f type=custom -f $1)
  fi

  echo $NETWORKS | xargs -r docker network rm
  echo "---Networks removed!"
  echo
}

parse_options () {
  if [[ $# -eq 0 ]]; then
    echo "See '$filename --help'"
  fi
  while [[ $# -gt 0 ]]; do
    case $1 in
      --filter | -f)
        show_warning
        remove_containers $2
        remove_volumes $2
        remove_networks $2
        shift
        shift
        ;;
      --all | -a)
        show_warning
        remove_containers
        remove_volumes
        remove_networks
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

  check_dependencies
  parse_options "$@"
}

main "$@"
