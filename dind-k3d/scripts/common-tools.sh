#!/usr/bin/env bash

apt-get update
# echo "Installing required packages ..."
apt-get -y install --no-install-recommends apt-utils dialog
apt-get -y install --no-install-recommends coreutils gnupg2 ca-certificates apt-transport-https
apt-get -y install --no-install-recommends software-properties-common make build-essential
apt-get -y install --no-install-recommends git wget curl bash-completion jq gettext iputils-ping
apt-get -y install --no-install-recommends tar g++ gcc libc6-dev pkg-config