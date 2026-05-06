name: spec-kit
base: core24
version: "${VERSION}"
title: GitHub Spec Kit
summary: GitHub Spec Kit - Build high-quality software faster
description: |
  An open source toolkit that allows you to focus on product scenarios and
  predictable outcomes instead of vibe coding every piece from scratch.
license: Apache-2.0

website: https://github.com/github/spec-kit
source-code: https://github.com/github/spec-kit
issues: https://github.com/github/spec-kit/issues
contact: https://github.com/github/spec-kit/discussions
donation: https://github.com/github/spec-kit

grade: stable
confinement: strict

apps:
  specify:
    command: bin/specify
    plugs:
      - home
      - network
      - network-bind

parts:
  specify-cli:
    plugin: python
    source: https://github.com/github/spec-kit/archive/refs/tags/v${VERSION}.tar.gz
    python-packages:
      - hatchling
    build-environment:
      - PATH: "$HOME/.local/bin:$PATH"
    stage-packages:
      - python3-venv
      - python3-pip
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

# vim: syntax=yaml expandtab
