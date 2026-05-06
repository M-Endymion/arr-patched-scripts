# arr-patched-scripts

*Patched `setup.bash` scripts for the *arr suite (Radarr, Lidarr, Sonarr, etc.)**

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

### How to Use – Radarr

1. Create the custom init folder:
   ```bash
   mkdir -p ~/docker/appdata/radarr-custom/custom-cont-init.d
   ```

2. Create the init script:
      ```bash
      nano ~/docker/appdata/radarr-custom/custom-cont-init.d/scripts_init.bash
      ```
      Paste this content:
      ```bash
      #!/usr/bin/with-contenv bash
      set -euo pipefail

      echo "Running patched Radarr setup script..."
      curl -sfL https://raw.githubusercontent.com/M-Endymion/arr-patched-scripts/main/radarr/setup.bash | bash

      exit 0
      ```

3. Make it executable and restart Radarr:
   ```bash
   chmod +x ~/docker/appdata/radarr-custom/custom-cont-init.d/scripts_init.bash
   docker compose restart radarr
   ```

4. Check logs:
   ```bash
   docker logs radarr --tail 100 -f
   ```

---
### How to Use – Sonarr

1. Create the custom init folder:
   ```bash
   mkdir -p ~/docker/appdata/sonarr-custom/custom-cont-init.d
   ```

2. Create the init script:
      ```bash
      nano ~/docker/appdata/sonarr-custom/custom-cont-init.d/scripts_init.bash
      ```
      Paste this content:
      ```bash
      #!/usr/bin/with-contenv bash
      set -euo pipefail

      echo "Running patched Sonarr setup script..."
      curl -sfL https://raw.githubusercontent.com/M-Endymion/arr-patched-scripts/main/sonarr/setup.bash | bash

      exit 0
      ```

3. Make it executable and restart Sonarr:
   ```bash
   chmod +x ~/docker/appdata/sonarr-custom/custom-cont-init.d/scripts_init.bash
   docker compose restart sonarr
   ```

4. Check logs:
   ```bash
   docker logs sonarr --tail 100 -f
   ```


---

### Other *arr Apps

Lidarr: Use the excellent Kickala/kickarr - https://github.com/Kickala/kickarr/tree/main

Readarr / Bazarr: Patches coming soon — request them if needed!

---

### Credits

Original scripts by RandomNinjaAtk/arr-scripts

Lidarr patch inspiration from Kickala/kickarr

Radarr patch created and maintained by M-Endymion

⭐ Feel free to star this repo if it helped you!

### License
MIT - Free to use, modify, and share.
