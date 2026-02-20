UPSTREAM_GIT := "https://github.com/google-gemini/gemini-cli"
UPSTREAM_DIR := ../../gemini-cli
VERSION := $(shell git -C ${UPSTREAM_DIR} tag --sort=-version:refname | grep -v nightly | grep -v preview | head -n 1 | tr -d v)
TARGET := gemini-cli_${VERSION}_amd64.snap

export VERSION := ${VERSION}

default:
	@echo "Current version: ${VERSION}"

snapcraft.yaml: snapcraft.yaml.mk
	@echo "Refreshing $@..."
	@envsubst < $< > $@

build: ${TARGET}

${TARGET}: snapcraft.yaml
	snapcraft pack

release: ${TARGET}
	snapcraft upload --release=stable $<

${UPSTREAM_DIR}:
	git clone ${UPSTREAM_GIT} $@

update: ${UPSTREAM_DIR}
	git -C ${UPSTREAM_DIR} pull

clean:
	$(RM) gemini-cli_*.snap snapcraft.yaml
