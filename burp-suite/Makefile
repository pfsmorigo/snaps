VERSION=$(shell grep ^version: snapcraft.yaml | cut -d":" -f2 | xargs)
SNAP_NAME=burp-suite_${VERSION}_amd64.snap

all: build install unsquashfs

build:
	snapcraft

clean: clean-unsquashfs
	$(RM) ${SNAP_NAME}
	snapcraft clean

install:
	sudo snap install --dangerous ${SNAP_NAME}

install-devmode:
	sudo snap install --dangerous --devmode ${SNAP_NAME}

unsquashfs: clean-unsquashfs
	unsquashfs ${SNAP_NAME}
	ls -la squashfs-root

clean-unsquashfs:
	$(RM) -r squashfs-root
