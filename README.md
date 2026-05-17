<div align="center">
  <img src="https://raw.githubusercontent.com/M-Endymion/arr-patched-scripts/main/thumbnail-arr.png" alt="arr-patched-scripts Banner" width="100%" />
</div>

<br>

# arr-patched-scripts

**Patched setup scripts for the arr suite (Radarr, Sonarr, Lidarr, etc.) in Docker**

Fixes common permission, XML parsing, and stability issues when using linuxserver.io containers.

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

---

## The Problem It Solves

Original [RandomNinjaAtk/arr-scripts](https://github.com/RandomNinjaAtk/arr-scripts) often fail in Docker due to:
- `getArrAppInfo` unable to read `/config/config.xml`
- Permission issues with the `abc` user
- Unbound variable errors under strict bash settings

These patched versions resolve those issues while keeping the excellent original functionality.

---

## Included Patches

- **Radarr** — `radarr/setup.bash`
- **Sonarr** — `sonarr/setup.bash`

(Lidarr: Use the excellent [Kickala/kickarr](https://github.com/Kickala/kickarr) instead)

---

## How to Use (Radarr Example)

```bash
# 1. Create custom init folder
mkdir -p ~/docker/appdata/radarr-custom/custom-cont-init.d

# 2. Create the init script
cat > ~/docker/appdata/radarr-custom/custom-cont-init.d/scripts_init.bash << 'EOF'
#!/usr/bin/with-contenv bash
set -euo pipefail

echo "🚀 Running patched Radarr setup script..."
curl -sfL https://raw.githubusercontent.com/M-Endymion/arr-patched-scripts/main/radarr/setup.bash | bash

exit 0
EOF

# 3. Make executable and restart
chmod +x ~/docker/appdata/radarr-custom/custom-cont-init.d/scripts_init.bash
docker compose restart radarr

4. Check logs:
   ```bash
   docker logs sonarr --tail 100 -f
   ```

Repeat similar steps for Sonarr.

---

### Key Fixes Included

- Robust Python XML parser for ```getArrAppInfo()```
- Safe permission handling ```(abc:users)```
- Additional build tools for Python packages
- Cleaner error handling and logging

---

### Credits

- Original scripts: RandomNinjaAtk/arr-scripts
- Inspiration from Kickala/kickarr
- Patches & maintenance: M-Endymion

All credit for core functionality goes to the original authors.

---

### About the Author

**Jason Ray (M-Endymion)**

IT Professional specializing in automation, Docker, and self-hosted infrastructure.

This repo demonstrates practical troubleshooting and scripting skills that transfer directly to enterprise DevOps and automation roles.
- LinkedIn: Jason Ray
- Open to opportunities

**Last Updated:** May 17, 2026
License: MIT (Patches) — Original works remain under GPL-3.0

---

