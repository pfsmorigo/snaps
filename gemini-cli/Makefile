UPSTREAM_GIT := "https://github.com/google-gemini/gemini-cli"
UPSTREAM_DIR := ../../gemini-cli
VERSION := $(shell git -C ${UPSTREAM_DIR} tag --sort=-version:refname | grep -v nightly | grep -v preview | head -n 1 | tr -d v)
TARGET := gemini-cli_${VERSION}_amd64.snap

export VERSION := ${VERSION}

${TARGET}: snapcraft.yaml
	@echo "\n* Build $@ with version ${VERSION}..."
	snapcraft pack

update: ${UPSTREAM_DIR}
	@echo "\n* Update upstrean project..."
	@git -C ${UPSTREAM_DIR} pull --tags

${UPSTREAM_DIR}:
	@echo "\n* Clone upstrean project..."
	git clone ${UPSTREAM_GIT} $@

snapcraft.yaml: snapcraft.yaml.mk
	@echo "* Refreshing $@..."
	@envsubst '$$VERSION' < $< > $@

release: ${TARGET}
	@echo "* Uploading $<..."
	snapcraft upload --release=stable $<

local-install: ${TARGET}
	sudo snap install --dangerous $<

clean:
	$(RM) gemini-cli_*.snap snapcraft.yaml
