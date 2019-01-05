#!/bin/bash

if ! snap info anbox 2> /dev/null | grep "refresh-date" > /dev/null; then
	log "Installing anbox..."
	snap install --devmode --beta anbox
else
	log "Updating anbox..."
	snap refresh --beta --devmode anbox
fi
