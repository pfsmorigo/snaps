name: gemini-cli
base: core24
version: "${VERSION}"
summary: Unofficial snap for Google Gemini CLI
description: |
  An open-source AI agent that brings the power of Gemini directly into
  your terminal.
title: Gemini CLI
license: Apache License 2.0
donation: N/A (Google-maintained project; no official donation link)
issues: https://github.com/google-gemini/gemini-cli/issues
source-code: https://github.com/google-gemini/gemini-cli
website: https://ai.google.dev/gemini-api/docs/quickstart

grade: stable
confinement: strict

apps:
  gemini:
    command: lib/node_modules/gemini-wrapper/node_modules/.bin/gemini
    plugs: [network, network-bind, home]

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

    override-pull: |
      craftctl default
      cat > package.json <<EOF
      {
        "name": "gemini-wrapper",
        "version": "$SNAPCRAFT_PROJECT_VERSION",
        "dependencies": {
          "@google/gemini-cli": "latest"
        }
      }
      EOF

# vim: syntax=yaml
