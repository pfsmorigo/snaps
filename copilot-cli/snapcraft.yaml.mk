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
      - git

    prime:
    - -lib/node_modules/copilot-wrapper/node_modules/@github/copilot/prebuilds/linux-arm64/*
    - -lib/node_modules/copilot-wrapper/node_modules/@github/copilot/clipboard/node_modules/@teddyzhu/clipboard-linux-arm64-gnu/*

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
