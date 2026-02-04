UPSTREAM_GIT := "https://github.com/google-gemini/gemini-cli"
UPSTREAM_DIR := ../../gemini-cli
VERSION := $(shell git -C ${UPSTREAM_DIR} tag --sort=-version:refname | grep -v nightly | grep -v preview | head -n 1 | tr -d v)
TARGET := gemini-cli_${VERSION}_amd64.snap

default:
	@echo "Current version: ${VERSION}"

build: ${TARGET}

${TARGET}:
	snapcraft pack

${UPSTREAM_DIR}:
	git clone ${UPSTREAM_GIT} $@

install: ${TARGET}
	sudo snap install --dangerous $<

release-stable: ${TARGET}
	snapcraft upload --release=stable $<

update: ${UPSTREAM_DIR}
	git -C ${UPSTREAM_DIR} fetch
	sed -i 's/^version: .*/version: "${VERSION}"/' snapcraft.yaml

clean:
	$(RM) gemini-cli_*.snap
