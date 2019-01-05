#!/bin/bash

check_mods() {
  if [ ! -e /dev/ashmem ] || [ ! -e /dev/binder ]; then
	  return 1
  else
	  return 0
  fi
}

load_mods() {
	if ! check_mods; then
		log "Kernel modules not loaded, loading them now"
		modprobe ashmem_linux
		modprobe binder_linux
	fi
}

if ! ls /etc/apt/sources.list.d/ | grep anbox-support > /dev/null; then
	add-apt-repository ppa:morphis/anbox-support
fi

if ! ls /var/lib/apt/lists/ | grep anbox-support > /dev/null; then
	apt-get update
fi

need_install=()
installed_kernel=false
kernel_type="$(dpkg -l | grep "ii  linux-image" | grep -o "linux-[a-z0-9.-]* "  | grep -v "[0-9]" | sed "s|linux-image-||g")" # most likely generic
for pkg in linux-headers-$kernel_type anbox-modules-dkms; do
	if ! dpkg -s "$pkg" > /dev/null 2> /dev/null; then
		need_install+=($pkg)
		log "Need to install $pkg"
	fi
done

if [ ! -z "$need_install" ]; then
	installed_kernel=true
	log "Installing ${need_install[*]}..."
	apt-get install -y "${need_install[@]}"
fi

load_mods

if ! check_mods && ! $installed_kernel; then
	log "Mods still not loaded, trying to reconfigure dkms"
	dpkg-reconfigure anbox-modules-dkms
	load_mods
fi

if ! check_mods; then
	log "Giving up, please fix kernel modules"
	exit 2
fi
