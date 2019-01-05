#!/bin/bash

log "Installing F-Droid..."

FDROID=$(curl -s https://f-droid.org/packages/org.fdroid.fdroid.privileged.ota/ | grep -o "https.*.zip" | sort -r | head -n 1)
FDROID_ZIP="$WORKDIR/$(basename $FDROID)"

wget -q --show-progress --continue -O "$FDROID_ZIP" "$FDROID"
TMPDIR="$WORKDIR/fdroid.tmp"
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"
mkdir -p "$OVERLAYDIR/system/app"
mkdir -p "$OVERLAYDIR/system/addon.d"
cd "$TMPDIR"

unzip "$FDROID_ZIP"

sed "s|/system|$OVERLAYDIR/system|g" -i META-INF/com/google/android/update-binary
sed "s|/cache|$TMPDIR|g" -i META-INF/com/google/android/update-binary
for cmd in umount mount unzip cd; do
  sed "s|^$cmd.*\$||g" -i META-INF/com/google/android/update-binary
done
sed "s|.*/proc/self/fd/.*||g" -i META-INF/com/google/android/update-binary
sed "s|rm -f |rm -rfv |g" -i META-INF/com/google/android/update-binary

bash -ex META-INF/com/google/android/update-binary

snap restart anbox.container-manager
