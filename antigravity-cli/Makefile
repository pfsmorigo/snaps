PROJECT := antigravity-cli
VERSION := 1.0.0
TARGET := ${PROJECT}_${VERSION}_amd64.snap

default: pack install

pack: ${TARGET}

${TARGET}: snapcraft.yaml
	snapcraft pack

release: released_${VERSION}

release-beta: released-beta_${VERSION}

released_${VERSION}: ${TARGET}
	snapcraft upload --release=stable $<
	touch $@

released-beta_${VERSION}: ${TARGET}
	snapcraft upload --release=beta $<
	touch $@

install: ${TARGET}
	sudo snap install --dangerous $<

clean:
	snapcraft clean
	$(RM) ${TARGET}
