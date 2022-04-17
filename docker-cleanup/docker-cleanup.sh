#!/bin/bash

set -e

show_warning () {
  read -p "---Remove all Docker containers, volumes and networks? [y/n] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit
  fi
}

remove_containers () {
  echo "---Removing containers..."
  CONTAINERS=$(docker container ls -q -a)
  echo $CONTAINERS | xargs -r docker container rm -f
  echo "---Containers removed!"
}

remove_volumes () {
  echo "---Removing volumes..."
  VOLUMES=$(docker volume ls -q)
  echo $VOLUMES | xargs -r docker volume rm -f
  echo "---Volumes removed!"
}

remove_networks () {
  echo "---Removing networks..."
  NETWORKS=$(docker network ls -q -f type=custom)
  echo $NETWORKS | xargs -r docker network rm
  echo "---Networks removed!"
}

main () {
  show_warning
  remove_containers
  remove_volumes
  remove_networks
}

main
