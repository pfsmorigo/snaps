name: claude-code
base: core24
version: "${VERSION}"
title: Claude Code
summary: Anthropic Claude Code
description: |
  Claude Code is an agentic coding tool that lives in your terminal,
  understands your codebase, and helps you code faster by executing routine
  tasks, explaining complex code, and handling git workflows - all through
  natural language commands.
license: Apache-2.0
website: https://code.claude.com/docs/en/overview
source-code: https://github.com/anthropics/claude-code
issues: https://github.com/anthropics/claude-code/issues
contact: https://github.com/anthropics/claude-code/discussions
donation: https://github.com/anthropics/claude-code
grade: stable
confinement: strict

apps:
  claude-code:
    command: bin/claude-code
    environment:
      PATH: $SNAP_USER_COMMON/local/bin:$PATH
      PYTHONPATH: $SNAP_USER_COMMON/local/lib/python3.12/site-packages:$SNAP_USER_COMMON/local/lib/python3.12/dist-packages:$SNAP/usr/lib/python3/dist-packages
      PIP_PREFIX: $SNAP_USER_COMMON
      PIP_BREAK_SYSTEM_PACKAGES: "1"
      QUILT_DIR: $SNAP/usr/share/quilt
    plugs:
      - network
      - network-bind
      - home
      - desktop
      - desktop-legacy
      - password-manager-service

parts:
  claude-code:
    plugin: nil
    build-packages:
      - curl
      - ca-certificates
    stage-packages:
      - libasound2
    override-build: |
      mkdir -p $SNAPCRAFT_PART_INSTALL/bin
      curl -fsSL https://claude.ai/install.sh | bash

# vim: syntax=yaml expandtab
