name: copilot-cli
base: core24
version: "${VERSION}"
title: Copilot CLI
summary: GitHub Copilot CLI
description: |
  An open-source AI agent that brings the power of Copilot directly into
  your terminal.
license: Apache-2.0
website: https://github.com/features/copilot/cli
source-code: https://github.com/github/copilot-cli
issues: https://github.com/github/copilot-cli/issues
contact: https://github.com/github/copilot-cli/discussions
donation: https://github.com/github/copilot-cli
grade: stable
confinement: strict

apps:
  copilot:
    command: bin/copilot
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
  copilot:
    plugin: nil
    build-packages:
      - curl
      - ca-certificates
    override-build: |
      mkdir -p $SNAPCRAFT_PART_INSTALL/bin
      curl -fsSL https://gh.io/copilot-install | PREFIX=$SNAPCRAFT_PART_INSTALL bash

# vim: syntax=yaml expandtab
