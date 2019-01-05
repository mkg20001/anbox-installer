#!/bin/bash

set -e

if [ "$(id -u)" != "0" ]; then
	echo "ERROR: You must be root! Please re-run with 'sudo bash $0'" >&2
	exit 2
fi

log() {
	echo "$(date): $*"
}
