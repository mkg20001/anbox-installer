#!/bin/bash

BASE="$(dirname $(readlink -f $0))"

. _/generic.sh

. _/dkms.sh

. _/anbox.sh

log "Installing playstore + houdini..."

. anbox-playstore-installer/install-playstore.sh

cd "$BASE"

. _/fdroid.sh

log "DONE!"
