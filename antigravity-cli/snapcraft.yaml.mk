name: antigravity-cli
base: core24
version: "${VERSION}"
title: Antigravity CLI
summary: Antigravity CLI is a tool for managing your Antigravity projects.
description: |
  Antigravity CLI understands your codebase, makes edits with your permission,
  and executes commands — right from your terminal.
license: Apache-2.0
website: https://antigravity.google/docs/cli-overview
source-code: https://github.com/google-antigravity/antigravity-cli
issues: https://github.com/google-antigravity/antigravity-cli/issues
contact: https://github.com/google-antigravity/antigravity-cli
donation: https://github.com/google-antigravity/antigravity-cli
grade: stable
confinement: strict

apps:
  antigravity-cli:
    command: bin/agy
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

parts:
  antigravity-cli:
    plugin: nil
    build-packages:
      - curl
      - ca-certificates
    stage-packages:
      - git
      - quilt
      - poppler-utils
      - curl
      - wget
      - devscripts
      - python3-apt
      - python3-pip
      - coreutils
    prime:
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
      curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir $SNAPCRAFT_PART_INSTALL/bin

# vim: syntax=yaml expandtab
