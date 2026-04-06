SUBDIRS := claude-code gemini-cli copilot-cli spec-kit

.PHONY: all $(SUBDIRS) pull-upstream build release install clean

all: build

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

pull-upstream build release install clean: $(SUBDIRS)

# Default goal if none specified
.DEFAULT_GOAL := build
