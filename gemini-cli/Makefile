UPSTREAM_GIT := "https://github.com/google-gemini/gemini-cli"
UPSTREAM_DIR := ../../gemini-cli
VERSION := $(shell git -C ${UPSTREAM_DIR} tag --sort=-version:refname | grep -v nightly | grep -v preview | head -n 1 | tr -d v)
TARGET := gemini-cli_${VERSION}_amd64.snap

export VERSION := ${VERSION}

define print_message
	@echo "\033[34m$(1)\033[0m"
endef

${TARGET}: refresh-upstream snapcraft.yaml
	$(call print_message,Build $@ with version ${VERSION}...)
	snapcraft pack

snapcraft.yaml: snapcraft.yaml.mk
	$(call print_message,Refreshing $@ with ${VERSION}...)
	@envsubst '$$VERSION' < $< > $@

release: ${TARGET}
	$(call print_message,Uploading $<...)
	snapcraft upload --release=stable $<

refresh-upstream: ${UPSTREAM_DIR}
	$(call print_message,Refresh upstrean project...)
	@git -C ${UPSTREAM_DIR} pull --tags

${UPSTREAM_DIR}:
	$(call print_message,Clone upstrean project...)
	git clone ${UPSTREAM_GIT} $@

local-install: ${TARGET}
	sudo snap install --dangerous $<

clean:
	$(RM) gemini-cli_*.snap snapcraft.yaml

.PHONY: snapcraft.yaml
