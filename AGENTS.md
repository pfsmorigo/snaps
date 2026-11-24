# AGENTS.md — Contributor & Agent Guide for Snaps Monorepo

Welcome to the `snaps` repository. This document serves as the primary technical specification, architectural reference, and operational guide for autonomous agents and human developers maintaining, building, and extending this codebase.

---

## 1. Project Overview & Packaging Philosophy

This repository is a monorepo containing packaging definitions for unofficial **Snap packages** of modern developer and AI CLI tools (e.g., Google Antigravity CLI, Anthropic Claude Code, GitHub Copilot CLI, Google Gemini CLI, and GitHub Spec Kit).

### Key Architectural Tenets:
1. **Strict Confinement (`core26`)**: Snaps are strictly confined by default to ensure secure, isolated execution on user systems without compromising host integrity.
2. **Vanilla Upstream Packaging**: Packaging definitions must never modify, patch, or alter upstream source code or binaries unless strictly necessary for snap confinement. Upstream binaries and packages are fetched directly from official release channels (GitHub releases, official installer scripts, or package registries).
3. **Automated Version Tracking**: Package versions are dynamically determined from upstream GitHub releases (`https://api.github.com/repos/${DOMAIN}/${PROJECT}/releases/latest`) at build time rather than being hardcoded.
4. **DRY Build System**: Shared build logic, packaging dependencies, and documentation templates are centralized in [common.mk](file:///home/pfsmorigo/projects/snaps/common.mk), [README.md.mk](file:///home/pfsmorigo/projects/snaps/README.md.mk), and [description.md.mk](file:///home/pfsmorigo/projects/snaps/description.md.mk).
5. **State & Cache Isolation**: Tools store runtime configuration and state inside `$SNAP_USER_COMMON` rather than versioned revision directories, ensuring persistent settings across snap updates.

---

## 2. Repository Layout

```text
snaps/
├── Makefile                # Top-level makefile for repository-wide orchestration
├── common.mk               # Shared Makefile logic symlinked by all snap directories
├── README.md               # Auto-generated project catalog and badges
├── README.md.mk            # Template for individual snap README.md files
├── description.md.mk       # Template for Snap Store description.md files
├── generate_readme.py      # Python script that generates root README.md from snap metadata
├── LICENSE                 # Repository license (Apache-2.0)
│
├── antigravity-cli/        # Snap wrapper for Google Antigravity CLI
│   ├── .env                # Snap metadata (COMPANY, TITLE, DOMAIN, PROJECT, etc.)
│   ├── Makefile            # Symlink -> ../common.mk
│   ├── snapcraft.yaml.mk   # Parameterized Snapcraft definition template
│   ├── README.md           # Generated README for this snap
│   ├── description.md      # Generated Snap Store description
│   └── images/             # Visual assets (logo, screenshot, banner)
│
├── claude-code/            # Snap wrapper for Anthropic Claude Code
├── copilot-cli/            # Snap wrapper for GitHub Copilot CLI
├── gemini-cli/             # Snap wrapper for Google Gemini CLI
└── spec-kit/               # Snap wrapper for GitHub Spec Kit CLI
```

---

## 3. The Build & Packaging System

The repository uses GNU Make and Snapcraft, with dynamic version resolution and automated template rendering.

### 3.1 Subdirectory Discovery ([Makefile](file:///home/pfsmorigo/projects/snaps/Makefile))
The root [Makefile](file:///home/pfsmorigo/projects/snaps/Makefile) dynamically discovers all snap subdirectories by searching for `.env` files:
```makefile
SUBDIRS := $(shell find . -name ".env" -exec dirname {} \; | sed 's|^\./||')
```
Running commands such as `make build`, `make release`, or `make clean` at the root will recursively invoke the target across all discovered subdirectories.

### 3.2 Common Build Pipeline ([common.mk](file:///home/pfsmorigo/projects/snaps/common.mk))
Each snap directory contains a symlink `Makefile -> ../common.mk`. The execution pipeline follows these steps:

```mermaid
flowchart TD
    A[Read .env] --> B[Fetch Upstream Version from GitHub API]
    B --> C[Create Version Directory: v${VERSION}]
    C --> D[Render snapcraft.yaml with envsubst]
    D --> E[Inject COMMON_LIBRARIES into stage-packages]
    E --> F[Run snapcraft pack inside v${VERSION}]
    F --> G[Generate Output: v${VERSION}/${PROJECT}_${VERSION}_amd64.snap]
```

1. **Environment Loading**: Loads `.env` from the current directory.
2. **Version Resolution**:
   ```makefile
   VERSION := $(shell curl -s https://api.github.com/repos/${DOMAIN}/${PROJECT}/releases/latest | jq -r .tag_name | sed 's/^v//')
   TARGET_DIR := v${VERSION}
   TARGET := ${TARGET_DIR}/${PROJECT}_${VERSION}_amd64.snap
   ```
3. **Template Substitution (`snapcraft.yaml.mk` → `snapcraft.yaml`)**:
   - `envsubst '$$VERSION'` substitutes the dynamic version string into the template.
   - The file is placed inside `${TARGET_DIR}/snapcraft.yaml`.
4. **Common Library Injection**:
   - If the rendered YAML includes `stage-packages:`, `common.mk` automatically appends the shared dependency list defined in `COMMON_LIBRARIES` (e.g., `git`, `curl`, `coreutils`, `python3-pip`, `golang-go`, `quilt`, `ssh-client`, etc.) to prevent duplicate maintenance across snaps.
5. **Snap Assembly**:
   - Changes into `${TARGET_DIR}` and invokes `snapcraft pack 2>&1 | tee snapcraft_pack_output`.
6. **Publishing Targets**:
   - `release`: Uploads to the Snap Store `stable` channel via `snapcraft upload --release=stable`.
   - `release-beta`: Uploads to the Snap Store `beta` channel via `snapcraft upload --release=beta`.

---

## 4. Snap Architecture & Confinement

All snaps in this repository target `base: core26` and strict confinement (`confinement: strict`).

### 4.1 Persistent State in `$SNAP_USER_COMMON`
In standard strict confinement, `$SNAP_USER_DATA` changes with each revision (e.g. `~/snap/<project>/1`, `~/snap/<project>/2`), which can reset auth tokens and history between updates. To avoid this, apps are configured with:

```yaml
environment:
  HOME: $SNAP_USER_COMMON
  XDG_DATA_HOME: $SNAP_USER_COMMON/.local/share
  XDG_STATE_HOME: $SNAP_USER_COMMON/.local/state
  XDG_CONFIG_HOME: $SNAP_USER_COMMON/.config
  PATH: $SNAP_USER_COMMON/local/bin:$PATH
  PYTHONPATH: $SNAP_USER_COMMON/local/lib/python3.12/site-packages:$SNAP_USER_COMMON/local/lib/python3.12/dist-packages:$SNAP/usr/lib/python3/dist-packages
  PIP_PREFIX: $SNAP_USER_COMMON
  PIP_BREAK_SYSTEM_PACKAGES: "1"
  GIT_EXEC_PATH: $SNAP/usr/lib/git-core
  GIT_TEMPLATE_DIR: $SNAP/usr/share/git-core/templates
  GIT_CONFIG_NOSYSTEM: 1
```

### 4.2 Standard Plugs & Permissions
- `network` & `network-bind`: Network and local server listening (e.g., local callbacks, MCP servers).
- `home`: Read/write access to non-hidden user files in `/home`.
- `desktop` & `desktop-legacy`: Browser opening for OAuth logins and documentation links.
- `password-manager-service`: Access to Secret Service API / system keyring (e.g., Copilot and Claude auth storage).

### 4.3 Filesystem Access Model
Because strict confinement hides dotfiles (e.g. `~/.config`, `~/.ssh`) and files outside `/home`:
1. **Bind Mount (Recommended)**:
   ```bash
   mkdir -p ~/snap/<project>/common/data
   sudo mount --bind /path/to/workdir ~/snap/<project>/common/data
   ```
2. **Home Plug Connection**:
   ```bash
   sudo snap connect <project>:home
   ```

### 4.4 Content Sharing Between Snaps (Slots & Plugs)
Tools in this monorepo can share binaries and runtimes via Snapcraft **content interfaces**:
- **Providers (Slots)**:
  - [gemini-cli/snapcraft.yaml.mk](file:///home/pfsmorigo/projects/snaps/gemini-cli/snapcraft.yaml.mk): Exposes the `gemini-cli` content slot pointing to `lib/node_modules/gemini-cli`.
  - [copilot-cli/snapcraft.yaml.mk](file:///home/pfsmorigo/projects/snaps/copilot-cli/snapcraft.yaml.mk): Exposes the `copilot-cli` content slot pointing to `bin`.
- **Consumers (Plugs)**:
  - [spec-kit/snapcraft.yaml.mk](file:///home/pfsmorigo/projects/snaps/spec-kit/snapcraft.yaml.mk): Connects to `gemini-cli` and `copilot-cli` via plugs so that `specify` can invoke Gemini and Copilot without bundling separate redundant copies.

### 4.5 Package Size Optimization (`prime` Filter Lists)
Snap packages bundle shared Linux libraries. To keep package sizes small, each `snapcraft.yaml.mk` defines an exclusion filter under `prime:` to exclude redundant libraries, test data, and development artifacts (e.g. `libgst*`, `libicu*`, `libunwind*`, Go testdata, and unneeded architecture prebuilds).

---

## 5. Packaging Patterns in the Repo

Depending on how the upstream tool is distributed, three packaging patterns are used:

| Pattern | Examples | Mechanism in `snapcraft.yaml.mk` |
|---|---|---|
| **Upstream Shell Installer** | [antigravity-cli](file:///home/pfsmorigo/projects/snaps/antigravity-cli), [claude-code](file:///home/pfsmorigo/projects/snaps/claude-code), [copilot-cli](file:///home/pfsmorigo/projects/snaps/copilot-cli) | `plugin: nil`, uses `override-build` to fetch and execute official installer scripts (e.g., `curl -fsSL ... \| bash`) directly into `$SNAPCRAFT_PART_INSTALL/bin`. |
| **NPM Package** | [gemini-cli](file:///home/pfsmorigo/projects/snaps/gemini-cli) | `plugin: npm`, uses `override-pull` to write a synthetic `package.json` pointing to `@google/gemini-cli: "latest"`, bundling Node runtime. |
| **Python / Hatchling** | [spec-kit](file:///home/pfsmorigo/projects/snaps/spec-kit) | `plugin: python`, downloads source tarball from GitHub releases, builds using Python build isolation and `hatchling`. |

---

## 6. Workflows & Command Reference

### Root Directory Commands
Executed from `/home/pfsmorigo/projects/snaps`:

| Command | Action |
|---|---|
| `make` / `make build` | Builds all snaps in all subdirectories |
| `make <snap-name>` | Builds a specific snap (e.g., `make antigravity-cli`) |
| `make list-snaps` | Lists all built `.snap` files across the repo and their disk sizes |
| `make clean` | Cleans build directories (`v*`) across all subdirectories |
| `python3 generate_readme.py` | Scans all `*/snapcraft.yaml.mk`, extracts titles, descriptions, and screenshots, and updates root [README.md](file:///home/pfsmorigo/projects/snaps/README.md) |

### Snap Subdirectory Commands
Executed from a snap folder (e.g., `cd antigravity-cli`):

| Command | Action |
|---|---|
| `make info` | Checks and prints the latest upstream release version from GitHub |
| `make build` | Prepares `v${VERSION}/snapcraft.yaml` and builds the snap package |
| `make install` | Installs the locally built snap using `--dangerous` flag |
| `make README.md` | Regenerates snap-level `README.md` from `../README.md.mk` using `.env` variables |
| `make description.md` | Regenerates snap-level `description.md` from `../description.md.mk` using `.env` |
| `make release` | Uploads snap to the Snap Store `stable` channel |
| `make release-beta` | Uploads snap to the Snap Store `beta` channel |
| `make clean` | Removes the `v${VERSION}` build directory |

---

## 7. Step-by-Step Guide: Adding a New Snap

When an agent or developer adds a new CLI tool to this repository, follow this checklist:

1. **Create the Snap Directory**:
   ```bash
   mkdir <new-snap-name>
   cd <new-snap-name>
   ```

2. **Create the `.env` File**:
   Create `<new-snap-name>/.env` containing:
   ```bash
   COMPANY="Organization Name"
   TITLE="Tool Name CLI"
   DOMAIN="github-org-or-user"
   PROJECT="repository-name"
   SANDBOX_HINT="Optional sandbox advice for the README"
   ```

3. **Symlink the Shared Makefile**:
   ```bash
   ln -s ../common.mk Makefile
   ```

4. **Author `snapcraft.yaml.mk`**:
   - Set `base: core26` and `version: "${VERSION}"`.
   - Set `confinement: strict`.
   - Configure `apps:` with appropriate binary entrypoint and environment variables (pointing `HOME` and `XDG_*` to `$SNAP_USER_COMMON`).
   - Define necessary plugs (`home`, `network`, `network-bind`, `desktop`, etc.).
   - Configure parts using the appropriate packaging pattern (installer script, npm, or python).
   - Add exclusion rules in `prime:` to strip unnecessary files.

5. **Generate Snap Documentation**:
   ```bash
   make README.md
   make description.md
   ```

6. **Add Visual Assets**:
   Create `<new-snap-name>/images/` and provide:
   - `screenshot.png` (required for [generate_readme.py](file:///home/pfsmorigo/projects/snaps/generate_readme.py))
   - `logo.png` (optional icon for Snap Store)

7. **Test the Build**:
   ```bash
   make info   # Verify upstream version lookup
   make build  # Build the snap package
   ```

8. **Update the Monorepo README**:
   From repository root, run:
   ```bash
   python3 generate_readme.py
   ```

9. **Commit Changes**:
   Ensure generated `v*` directories and `.snap` files are ignored (verify with `git status`).

---

## 8. Agent Guidelines & Best Practices

1. **Never bypass strict confinement** unless an upstream design explicitly demands classic confinement (requires Canonical approval for Store publication).
2. **Check GitHub API limits**: `VERSION` resolution relies on unauthenticated calls to `api.github.com`. If rate-limited, export `GITHUB_TOKEN` in your environment or set `VERSION` manually when testing.
3. **Maintain documentation integrity**: Run `python3 generate_readme.py` whenever a snap is added, removed, or its title/description in `snapcraft.yaml.mk` is modified.
4. **Commit Message File**: Keep `commit_message.txt` updated in the workspace root formatted for `git commit -F commit_message.txt`. Never overwrite or discard existing uncommitted notes; accumulate new changes and adjust existing ones. In commit messages, directly describe what changed rather than referencing task files or checklists (e.g., do not say "fixes from todo.md", "todo.txt", or "todo items"). The user deletes `commit_message.txt` after committing.
5. **Prime exclusions**: When upgrading base versions (e.g. core24 to core26) or adding packages to `COMMON_LIBRARIES`, inspect the built snap size with `make list-snaps` and tune the `prime:` block to keep package sizes optimal.
