This repository provides a **Snap package** for the Google Gemini CLI.

**Disclaimer**: This is not an official Google product. This snap is a community-maintained wrapper. It does not modify the original source code in any way; it simply clones the official repository and packages it for easy installation on Snap-supported Linux distributions.


**How to use**

For documentation about the Gemini CLI functionality itself or to report bug, please use the official upstream repository: https://github.com/google-gemini/gemini-cli

By default, snaps are strictly confined for security. If you need the Gemini CLI to access files, check the instructions at https://github.com/pfsmorigo/snaps/tree/main/gemini-cli#filesystem-access

**How this snap is built**

To ensure security and integrity, this snap follows a "vanilla" build process:

 - It pulls the latest stable source directly from https://github.com/google-gemini/gemini-cli
 - It packages the Node environment and dependencies into a confined snap.
 - No custom patches or external scripts are added to the Gemini source code.


**Resources**

The source code for this snap is available here:
https://github.com/pfsmorigo/snaps/tree/main/gemini-cli

If there are issues with the packaging (e.g., file permissions, snapcraft errors), please open an issue:
https://github.com/pfsmorigo/snaps/issues
