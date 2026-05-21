PROJECT := antigravity-cli
VERSION := 1.0.0
TARGET := ${PROJECT}_${VERSION}_amd64.snap

default: pack install

pack: ${TARGET}

${TARGET}: snapcraft.yaml
	snapcraft pack

install: ${TARGET}
	sudo snap install --dangerous $<

clean:
	snapcraft clean
	$(RM) ${TARGET}
