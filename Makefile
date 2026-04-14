SUBDIRS := $(shell find . -name ".env" -exec dirname {} \; | sed 's|^\./||')

.PHONY: all $(SUBDIRS) pull-upstream build release install clean

all: build

$(SUBDIRS):
	@echo "\n\033[33m\e[1m$(@)\e[21m\033[0m"
	@$(MAKE) -C $@ $(MAKECMDGOALS)

pull-upstream build release install clean: $(SUBDIRS)

# Default goal if none specified
.DEFAULT_GOAL := build
