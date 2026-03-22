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
    plugs:
      - network
      - network-bind
      - home
      - desktop
      - desktop-legacy

parts:
  claude-code:
    plugin: npm
    source: .
    npm-include-node: true
    npm-node-version: 20.14.0

    # We need python/make/g++ because some npm dependencies build native modules
    build-packages:
      - build-essential
      - pkg-config
      - python3
    stage-packages:
      - libasound2
      - git

    prime:
      - -lib/node_modules/claude-code-wrapper/node_modules/@anthropic-ai/claude-code/vendor/audio-capture/arm64-linux/*
      - -lib/node_modules/claude-code-wrapper/node_modules/@anthropic-ai/claude-code/vendor/tree-sitter-bash/arm64-linux/*
      - -lib/node_modules/claude-code-wrapper/node_modules/@img/sharp-linux-x64/*
      - -lib/node_modules/claude-code-wrapper/node_modules/@img/sharp-libvips-linux-x64/*

    override-prime: |
      craftctl default
      ln -sf ../lib/node_modules/claude-code-wrapper/node_modules/@anthropic-ai/claude-code bin/claude-code
      ln -sf ../lib/node_modules/claude-code-wrapper/node_modules/@anthropic-ai/claude-code bin/abcde

    override-pull: |
      craftctl default
      cat > package.json <<EOF
      {
        "name": "claude-code-wrapper",
        "version": "${VERSION}",
        "dependencies": {
          "@anthropic-ai/claude-code": "latest"
        }
      }
      EOF

# vim: syntax=yaml
