name: gemini-cli
base: core24
version: "${VERSION}"
title: Gemini CLI
summary: Google Gemini CLI
description: |
  An open-source AI agent that brings the power of Gemini directly into
  your terminal.
license: Apache-2.0

website: https://ai.google.dev/gemini-api/docs/quickstart
source-code: https://github.com/google-gemini/gemini-cli
issues: https://github.com/google-gemini/gemini-cli/issues
contact: https://github.com/google-gemini/gemini-cli/discussions
donation: https://github.com/google-gemini/gemini-cli

grade: stable
confinement: strict

apps:
  gemini:
    command: lib/node_modules/gemini-cli/node_modules/.bin/gemini
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
      GIT_EXEC_PATH: $SNAP/usr/lib/git-core
      GIT_TEMPLATE_DIR: $SNAP/usr/share/git-core/templates
      GIT_CONFIG_NOSYSTEM: 1
    plugs:
      - network
      - network-bind
      - home
      - desktop
      - desktop-legacy

slots:
  bin:
    interface: content
    content: gemini-cli
    read:
      - lib/node_modules/gemini-cli

parts:
  gemini:
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
      - libx11-6
      - libsecret-1-0
    prime:
      - -lib/node_modules/gemini-cli/node_modules/@github/keytar/prebuilds/linux-arm/*
      - -lib/node_modules/gemini-cli/node_modules/@github/keytar/prebuilds/linux-arm64/*
      - -lib/node_modules/gemini-cli/node_modules/@github/keytar/prebuilds/linux-armv7l/*
      - -lib/node_modules/gemini-cli/node_modules/@github/keytar/prebuilds/linux-ia32/*
      - -lib/node_modules/gemini-cli/node_modules/@github/keytar/prebuilds/linuxmusl-arm/*
      - -lib/node_modules/gemini-cli/node_modules/@github/keytar/prebuilds/linuxmusl-arm64/*
      - -lib/node_modules/gemini-cli/node_modules/tree-sitter-bash/prebuilds/linux-arm64/*
      - -usr/lib/x86_64-linux-gnu/libcurl.so*
      - -usr/lib/x86_64-linux-gnu/libfreebl3.so
      - -usr/lib/x86_64-linux-gnu/libfreeblpriv3.so
      - -usr/lib/x86_64-linux-gnu/libgstcheck-1.0.so*
      - -usr/lib/x86_64-linux-gnu/libgstcontroller-1.0.so*
      - -usr/lib/x86_64-linux-gnu/libgstnet-1.0.so*
      - -usr/lib/x86_64-linux-gnu/libicui18n.so*
      - -usr/lib/x86_64-linux-gnu/libicuio.so*
      - -usr/lib/x86_64-linux-gnu/libicutest.so*
      - -usr/lib/x86_64-linux-gnu/libicutu.so*
      - -usr/lib/x86_64-linux-gnu/libnssckbi.so
      - -usr/lib/x86_64-linux-gnu/libnssdbm3.so
      - -usr/lib/x86_64-linux-gnu/libsoftokn3.so
      - -usr/lib/x86_64-linux-gnu/libssl3.so
      - -usr/lib/x86_64-linux-gnu/libunwind-coredump.so*
      - -usr/lib/x86_64-linux-gnu/libunwind-ptrace.so*
      - -usr/lib/x86_64-linux-gnu/libunwind-x86_64.so*
      - -usr/lib/x86_64-linux-gnu/preloadable_libintl.so
    override-pull: |
      craftctl default
      cat > package.json <<EOF
      {
        "name": "gemini-cli",
        "version": "${VERSION}",
        "dependencies": {
          "@google/gemini-cli": "latest"
        }
      }
      EOF

# vim: syntax=yaml expandtab
