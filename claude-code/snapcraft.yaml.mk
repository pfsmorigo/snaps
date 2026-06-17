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
    command: bin/claude
    environment:
      PATH: $SNAP_USER_COMMON/local/bin:$PATH
      PYTHONPATH: $SNAP_USER_COMMON/local/lib/python3.12/site-packages:$SNAP_USER_COMMON/local/lib/python3.12/dist-packages:$SNAP/usr/lib/python3/dist-packages
      PIP_PREFIX: $SNAP_USER_COMMON
      PIP_BREAK_SYSTEM_PACKAGES: "1"
      QUILT_DIR: $SNAP/usr/share/quilt
      HOME: $SNAP_USER_COMMON
      XDG_DATA_HOME: $SNAP_USER_COMMON/.local/share
      XDG_STATE_HOME: $SNAP_USER_COMMON/.local/state
      XDG_CONFIG_HOME: $SNAP_USER_COMMON/.config
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
    prime:
      - -usr/lib/x86_64-linux-gnu/libasound.so*
      - -usr/lib/x86_64-linux-gnu/libfreebl3.so
      - -usr/lib/x86_64-linux-gnu/libfreeblpriv3.so
      - -usr/lib/x86_64-linux-gnu/libicui18n.so*
      - -usr/lib/x86_64-linux-gnu/libicuio.so*
      - -usr/lib/x86_64-linux-gnu/libicutest.so*
      - -usr/lib/x86_64-linux-gnu/libicutu.so*
      - -usr/lib/x86_64-linux-gnu/libnssckbi.so
      - -usr/lib/x86_64-linux-gnu/libnssdbm3.so
      - -usr/lib/x86_64-linux-gnu/libsoftokn3.so
      - -usr/lib/x86_64-linux-gnu/libssl3.so
      - -usr/lib/x86_64-linux-gnu/preloadable_libintl.so
    override-build: |
      mkdir -p $SNAPCRAFT_PART_INSTALL/bin
      curl -fsSL https://claude.ai/install.sh | bash
      cp -L /root/.local/bin/claude $SNAPCRAFT_PART_INSTALL/bin/claude

# vim: syntax=yaml expandtab
