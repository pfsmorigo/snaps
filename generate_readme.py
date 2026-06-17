import os
import yaml
from pathlib import Path

def extract_info(file_path):
    with open(file_path, 'r') as f:
        content = f.read()
        try:
            data = yaml.safe_load(content)
            if not data:
                return None

            name = data.get('name')
            path = file_path.parent

            # Look for a screenshot in the images directory
            images_dir = path / 'images'
            screenshot_path = None
            if images_dir.exists():
                screenshots = list(images_dir.glob('screenshot.png'))
                if screenshots:
                    screenshot_path = screenshots[0].relative_to(Path('.'))

            return {
                'name': name,
                'title': data.get('title', name),
                'description': data.get('description', 'No description provided.').strip(),
                'path': path,
                'screenshot': screenshot_path
            }
        except yaml.YAMLError as exc:
            print(f"Error parsing {file_path}: {exc}")
            return None

def main():
    snaps = []
    # Search for snapcraft.yaml.mk files in subdirectories
    for path in Path('.').glob('*/snapcraft.yaml.mk'):
        info = extract_info(path)
        if info:
            snaps.append(info)

    if not snaps:
        print("No snapcraft.yaml.mk files found.")
        return

    # Sort snaps by title alphabetically
    snaps.sort(key=lambda x: (x['title'] or '').lower())

    readme_content = "# Snaps Repository\n\n"
    readme_content += "This repository contains unofficial snap wrappers for various tools.\n\n"
    readme_content += "## Available Snaps\n\n"

    for snap in snaps:
        title = snap['title'] or snap['name'] or "Unknown"
        rel_path = snap['path']
        name = snap['name']

        readme_content += f"### [{title}]({rel_path})\n\n"

        # Description immediately after title
        readme_content += f"{snap['description']}\n\n"

        # Screenshot
        if snap['screenshot']:
            readme_content += f"![{title} Screenshot]({snap['screenshot']})\n\n"

        # Add Snap Store badges (Status, Trending, and Install Button)
        readme_content += f"[![{name}](https://snapcraft.io/{name}/badge.svg)](https://snapcraft.io/{name})\n"
        readme_content += f"[![{name}](https://snapcraft.io/{name}/trending.svg?name=0)](https://snapcraft.io/{name})\n\n"
        readme_content += f"[![Get it from the Snap Store](https://snapcraft.io/en/dark/install.svg)](https://snapcraft.io/{name})\n\n"

        readme_content += "---\n\n"

    with open('README.md', 'w') as f:
        f.write(readme_content)

    print(f"Successfully generated README.md with {len(snaps)} snaps.")

if __name__ == "__main__":
    main()
