# Anthropics Claude Code (Unofficial Snap)

This repository provides a **Snap package** for the [Anthropics Claude Code](https://github.com/anthropics/claude-code).

### Disclaimer

**This is not an official Anthropics product.** This snap is a community-maintained wrapper. It does not modify the original source code in any way; it simply clones the official repository and packages it for easy installation on Snap-supported Linux distributions.


## How it Works

To ensure security and integrity, this snap follows a "vanilla" build process:

 - It pulls the latest stable source directly from https://github.com/anthropics/claude-code
 - It packages the Node environment and dependencies into a confined snap.
 - No custom patches or external scripts are added to the claude-code source code.


## Filesystem Access

By default, snaps are strictly confined for security. If you need the Claude Code to access files, you have two main options:

### 1. Accessing External Directories (Recommended)

You can make any directory accessible to the snap without granting full home directory permissions by using a **bind mount** into the snap's private `common` folder. This is the most secure method.

```bash
# Create a directory inside the snap's writable area
mkdir -p ~/snap/claude-code/common/data

# Mount your external directory there
sudo mount --bind /path/to/your/files ~/snap/claude-code/common/data
```
The files will then be available to the CLI at the path `~/snap/claude-code/common/data`.

### 2. Home Directory Access (Broad Permissions)

If you prefer to allow the snap to access your entire home directory (excluding hidden files), run:

```bash
sudo snap connect claude-code:home
```


##  Contributing

If there are issues with the packaging (e.g., file permissions, snapcraft errors), please open an issue in this repository.

If there are bugs within the Claude Code functionality itself, please report them to the official upstream repository.
