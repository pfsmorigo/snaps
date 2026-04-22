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
    command: lib/node_modules/copilot-wrapper/node_modules/.bin/copilot
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
  copilot:
    plugin: npm
    source: .
    npm-include-node: true
    npm-node-version: 20.14.0

    # We need python/make/g++ because some npm dependencies build native modules
    build-packages:
      - python3
      - build-essential
      - libsecret-1-dev
      - pkg-config
    stage-packages:
      - libsecret-1-0
      - libpipewire-0.3-0
      - libx11-6
      - libxtst6
      - libei1

    prime:
    - -lib/node_modules/copilot-wrapper/node_modules/@github/copilot/prebuilds/linux-arm64/*
    - -lib/node_modules/copilot-wrapper/node_modules/@github/copilot/clipboard/node_modules/@teddyzhu/clipboard-linux-arm64-gnu/*
    - -usr/lib/x86_64-linux-gnu/libicui18n.so*
    - -usr/lib/x86_64-linux-gnu/libicuio.so*
    - -usr/lib/x86_64-linux-gnu/libicutest.so*
    - -usr/lib/x86_64-linux-gnu/libicutu.so*
    - -usr/lib/x86_64-linux-gnu/preloadable_libintl.so
    - -usr/lib/x86_64-linux-gnu/libfreebl3.so
    - -usr/lib/x86_64-linux-gnu/libfreeblpriv3.so
    - -usr/lib/x86_64-linux-gnu/libnssckbi.so
    - -usr/lib/x86_64-linux-gnu/libnssdbm3.so
    - -usr/lib/x86_64-linux-gnu/libsoftokn3.so
    - -usr/lib/x86_64-linux-gnu/libssl3.so

    override-pull: |
      craftctl default
      cat > package.json <<EOF
      {
        "name": "copilot-wrapper",
        "version": "${VERSION}",
        "dependencies": {
          "@github/copilot": "latest"
        }
      }
      EOF

# vim: syntax=yaml
