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
    command: lib/node_modules/gemini-wrapper/node_modules/.bin/gemini
    plugs:
      - network
      - network-bind
      - home
      - desktop
      - desktop-legacy

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
      - git
      - quilt
      - poppler-utils

    prime:
      - -lib/node_modules/gemini-wrapper/node_modules/tree-sitter-bash/prebuilds/linux-arm64/*
      - -usr/lib/x86_64-linux-gnu/libicuio.so*
      - -usr/lib/x86_64-linux-gnu/libicutest.so*
      - -usr/lib/x86_64-linux-gnu/preloadable_libintl.so
      - -usr/lib/x86_64-linux-gnu/libicui18n.so*
      - -usr/lib/x86_64-linux-gnu/libicutu.so*

    override-pull: |
      craftctl default
      cat > package.json <<EOF
      {
        "name": "gemini-wrapper",
        "version": "${VERSION}",
        "dependencies": {
          "@google/gemini-cli": "latest"
        }
      }
      EOF

# vim: syntax=yaml
