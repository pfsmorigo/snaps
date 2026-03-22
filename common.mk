UPSTREAM_DIR := ../../${PROJECT_NAME}
VERSION := $(shell git -C ${UPSTREAM_DIR} tag --sort=-version:refname | grep -v nightly | grep -v preview | head -n 1 | tr -d v 2>/dev/null)
TARGET_DIR := v${VERSION}
TARGET := ${TARGET_DIR}/${PROJECT_NAME}_${VERSION}_amd64.snap

export VERSION := ${VERSION}

define print_message
	@echo "\n\033[34m$(1)\033[0m"
endef

default: pull-upstream release

pull-upstream: ${UPSTREAM_DIR}
	$(call print_message,Refresh upstream project...)
	@git -C ${UPSTREAM_DIR} pull --tags
	@echo "Last tag: ${VERSION}"

${UPSTREAM_DIR}:
	$(call print_message,Clone upstream project...)
	git clone ${UPSTREAM_GIT} $@

release: ${TARGET_DIR}/released

${TARGET_DIR}/released: ${TARGET}
	$(call print_message,Uploading $<...)
	snapcraft upload --release=stable $<
	touch $@

${TARGET_DIR}/snapcraft.yaml: snapcraft.yaml.mk
	$(call print_message,Creating $@...)
	mkdir -p ${TARGET_DIR}
	@envsubst '$$VERSION' < $< > $@

${TARGET}: ${TARGET_DIR}/snapcraft.yaml
	$(call print_message,Build $@...)
	cd ${TARGET_DIR} && snapcraft pack

install: ${TARGET}
	sudo snap install --dangerous $<

clean:
	snapcraft clean
	$(RM) -rf v[0-9]*
