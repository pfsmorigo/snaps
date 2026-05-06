name: opencode
base: core24
version: "${VERSION}"
title: OpenCode
summary: The open source coding agent.
description: |
  OpenCode is an open source AI coding agent. It’s available as a terminal-based
  interface, desktop app, or IDE extension.
license: Apache-2.0

website: https://opencode.ai/
source-code: https://github.com/anomalyco/opencode
issues: https://github.com/anomalyco/opencode/issues/new
contact: https://github.com/anomalyco/opencode
donation: https://github.com/anomalyco/opencode

grade: stable
confinement: strict

apps:
  opencode:
    command: lib/node_modules/opencode-wrapper/node_modules/.bin/opencode
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

# Ubuntu uses the glibc library by default, whereas the npm package was
# compiled for systems using the musl C library
layout:
  /usr/lib/libc.musl-x86_64.so.1:
    symlink: $SNAP/usr/lib/x86_64-linux-musl/libc.so

parts:
  opencode:
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
      - musl

    prime:
      - -usr/lib/x86_64-linux-gnu/libXtst.so*
      - -usr/lib/x86_64-linux-gnu/libei.so*
      - -usr/lib/x86_64-linux-gnu/libfreebl3.so
      - -usr/lib/x86_64-linux-gnu/libfreeblpriv3.so
      - -usr/lib/x86_64-linux-gnu/libicui18n.so*
      - -usr/lib/x86_64-linux-gnu/libicuio.so*
      - -usr/lib/x86_64-linux-gnu/libicutest.so*
      - -usr/lib/x86_64-linux-gnu/libicutu.so*
      - -usr/lib/x86_64-linux-gnu/libnssckbi.so
      - -usr/lib/x86_64-linux-gnu/libnssdbm3.so
      - -usr/lib/x86_64-linux-gnu/libpipewire-0.3.so*
      - -usr/lib/x86_64-linux-gnu/libsecret-1.so*
      - -usr/lib/x86_64-linux-gnu/libsoftokn3.so
      - -usr/lib/x86_64-linux-gnu/libssl3.so
      - -usr/lib/x86_64-linux-gnu/preloadable_libintl.so

    override-pull: |
      craftctl default
      cat > package.json <<EOF
      {
        "name": "opencode-wrapper",
        "version": "${VERSION}",
        "dependencies": {
          "opencode-ai": "latest"
        }
      }
      EOF

# vim: syntax=yaml expandtab
