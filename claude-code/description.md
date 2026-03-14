This repository provides a **Snap package** for the Anthropic Claude Code.


**Disclaimer**: This is not an official Anthropic product. This snap is a community-maintained wrapper. It does not modify the original source code in any way; it simply clones the official repository and packages it for easy installation on Snap-supported Linux distributions.


**How to use**

For documentation about the Claude Code functionality itself or to report bug, please use the official upstream repository: https://github.com/anthropics/claude-code

By default, snaps are strictly confined for security. If you need the Claude Code to access files, check the instructions at https://github.com/pfsmorigo/snaps/tree/main/claude-code#filesystem-access


**How this snap is built**

To ensure security and integrity, this snap follows a "vanilla" build process:

 - It pulls the latest stable source directly from https://github.com/anthropics/claude-code
 - It packages the Python environment and dependencies into a confined snap.
 - No custom patches or external scripts are added to the Claude Code source code.


**Resources**

The source code for this snap is available here:
https://github.com/pfsmorigo/snaps/tree/main/claude-code

If there are issues with the packaging (e.g., file permissions, snapcraft errors), please open an issue:
https://github.com/pfsmorigo/snaps/issues
