# arr-patched-scripts

**Patched `setup.bash` scripts for the *arr suite (Radarr, Lidarr, Sonarr, etc.)**

Fixes the common Docker issues when using [RandomNinjaAtk/arr-scripts](https://github.com/RandomNinjaAtk/arr-scripts) with linuxserver.io containers.

### The Problem This Fixes
The original setup scripts often fail in Docker because:
- The `getArrAppInfo` function cannot reliably read `/config/config.xml`
- Permission problems with the `abc` user
- Unbound variable errors under `set -euo pipefail`

This is the same issue you fixed in Lidarr using [Kickala/kickarr](https://github.com/Kickala/kickarr).

### The Fix (included in these patched versions)
- Robust Python XML parser for `getArrAppInfo()`
- Safe permissions (`abc:users` + correct chmod)
- Extra build tools needed for Python packages
- Cleaner code and better error handling

---

### How to Use – Radarr (Example)

1. Create the custom init folder:
   ```bash
   mkdir -p ~/docker/appdata/radarr-custom/custom-cont-init.d
