SUBDIRS := $(shell find . -name ".env" -exec dirname {} \; | sed 's|^\./||')

.PHONY: all $(SUBDIRS) pull-upstream build release install clean list-snaps

all: build

$(SUBDIRS):
	@echo "\n\033[33m\e[1m$(@)\e[21m\033[0m"
	@$(MAKE) -C $@ $(MAKECMDGOALS)

pull-upstream build release install clean: $(SUBDIRS)

list-snaps:
	@find . -name "*.snap" -exec du -h {} + | sort -k2

# Default goal if none specified
.DEFAULT_GOAL := build
