# Gemini CLI (Unofficial Snap)

This repository provides a **Snap package** for the [Google Gemini CLI](https://github.com/google-gemini/gemini-cli).

### ⚠️ Disclaimer

**This is not an official Google product.** This snap is a community-maintained wrapper. It does not modify the original source code in any way; it simply clones the official repository and packages it for easy installation on Snap-supported Linux distributions.


## Installation

You can install the snap directly from this repository (if you are building locally) or from the Snap Store:

```bash
sudo snap install gemini-cli
```

Note: Depending on your snap's configuration, you may need to manually connect the network interface:

```bash
sudo snap connect gemini-cli:network
```


## How it Works

To ensure security and integrity, this snap follows a "vanilla" build process:

 - It pulls the latest stable source directly from https://github.com/google-gemini/gemini-cli
 - It packages the Python environment and dependencies into a confined snap.
 - No custom patches or external scripts are added to the Gemini source code.


##  Configuration

Before using the CLI, you will need an API key from the Google AI Studio.

Once you have your key, export it to your environment:

```bash
export GOOGLE_API_KEY='your_api_key_here'
```

##  Contributing

If there are issues with the packaging (e.g., file permissions, snapcraft errors), please open an issue in this repository.

If there are bugs within the Gemini CLI functionality itself, please report them to the official upstream repository.
