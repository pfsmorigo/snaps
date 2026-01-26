UPSTREAM_GIT := "https://github.com/google-gemini/gemini-cli"
UPSTREAM_DIR := "../../gemini-cli"
VERSION := $(shell git -C ${UPSTREAM_DIR} tag --sort=-version:refname | head -n 20 | grep -v nightly | grep -v preview | head -n 1 | tr -d v)
TARGET := gemini-cli_${VERSION}_amd64.snap

latest: ${TARGET}

${TARGET}:
	sed -i 's/^version: .*/version: "${VERSION}"/' snapcraft.yaml
	snapcraft pack

$UPSTREAM_GIT: ${UPSTREAM_DIR}
	git clone $@ $<

install: ${TARGET}
	sudo snap install --dangerous $<

clean:
	$(RM) gemini-cli_*.snap
