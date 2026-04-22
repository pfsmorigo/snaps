include .env

VERSION := $(shell curl -s https://api.github.com/repos/${DOMAIN}/${PROJECT}/tags | jq -r ".[].name" | grep -e "-dev" -v -e "-rc" -e "-alpha" -e "-beta" -e "-pre" -e "-nightly" | head -n 1 | sed 's/^v//')
TARGET_DIR := v${VERSION}
TARGET := ${TARGET_DIR}/${PROJECT}_${VERSION}_amd64.snap

export VERSION := ${VERSION}
export COMMON_LIBRARIES := git quilt poppler-utils curl wget devscripts python3-apt python3-pip

define print_message
	@echo "\n\033[34m$(1)\033[0m"
endef

default: build
	@echo "Lastest release is ${VERSION}"
	@echo "Snap size is $$(du -h ${TARGET} | cut -f1)"

release: ${TARGET_DIR}/released

README.md: ../README.md.mk
	$(call print_message,Refreshing $@...)
	@set -a; . ./.env; set +a; envsubst < $< > $@

${TARGET_DIR}/released: ${TARGET}
	$(call print_message,Uploading $<...)
	snapcraft upload --release=stable $<
	touch $@

${TARGET_DIR}/snapcraft.yaml: snapcraft.yaml.mk
	$(call print_message,Creating $@...)
	mkdir -p ${TARGET_DIR}
	@envsubst '$$VERSION' < $< > $@
	@if grep -q "stage-packages:" $@; then \
		for lib in $(COMMON_LIBRARIES); do \
			if ! grep -q -- "- $$lib" $@; then \
				sed -i "/stage-packages:/a \      - $$lib" $@; \
			fi; \
		done; \
	fi

build: ${TARGET}

${TARGET}: ${TARGET_DIR}/snapcraft.yaml
	$(call print_message,Build $@...)
	cd ${TARGET_DIR} && snapcraft pack

install: ${TARGET}
	sudo snap install --dangerous $<

clean:
	snapcraft clean
	$(RM) -rf v[0-9]*
