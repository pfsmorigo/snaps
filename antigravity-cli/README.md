# Google Antigravity CLI (Unofficial Snap)

[![antigravity-cli](https://snapcraft.io/antigravity-cli/badge.svg)](https://snapcraft.io/antigravity-cli)
[![antigravity-cli](https://snapcraft.io/antigravity-cli/trending.svg?name=0)](https://snapcraft.io/antigravity-cli)

[![Get it from the Snap Store](https://snapcraft.io/en/dark/install.svg)](https://snapcraft.io/antigravity-cli)

This repository provides a **Snap package** for the [Google Antigravity CLI](https://github.com/google-antigravity/antigravity-cli).

### Disclaimer

**This is not an official Google product.** This snap is a community-maintained wrapper. It does not modify the original source code in any way; it simply clones the official repository and packages it for easy installation on Snap-supported Linux distributions.


## How it Works

To ensure security and integrity, this snap follows a "vanilla" build process:

 - It pulls the latest stable source directly from https://github.com/google-antigravity/antigravity-cli
 - It packages the Node environment and dependencies into a confined snap.
 - No custom patches or external scripts are added to the antigravity-cli source code.


## Filesystem Access

By default, snaps are strictly confined for security. If you need the Antigravity CLI to access files, you have two main options:

### 1. Accessing External Directories (Recommended)

You can make any directory accessible to the snap without granting full home directory permissions by using a **bind mount** into the snap's private `common` folder. This is the most secure method.

```bash
# Create a directory inside the snap's writable area
mkdir -p ~/snap/antigravity-cli/common/data

# Mount your external directory there
sudo mount --bind /path/to/your/files ~/snap/antigravity-cli/common/data
```
The files will then be available to the CLI at the path `~/snap/antigravity-cli/common/data`.

### 2. Home Directory Access (Broad Permissions)

If you prefer to allow the snap to access your entire home directory (excluding hidden files), run:

```bash
sudo snap connect antigravity-cli:home
```
**Hint:** If you grant full home directory access, you can still protect your sensitive files by using the 'antigravity-cli --sandbox' feature. This restricts the CLIs operations to the current project directory, preventing it from accidentally modifying or reading files outside your workspace.

##  Contributing

If there are issues with the packaging (e.g., file permissions, snapcraft errors), please open an issue in this repository.

If there are bugs within the Antigravity CLI functionality itself, please report them to the official upstream repository.
