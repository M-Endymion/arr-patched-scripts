#!/usr/bin/with-contenv bash
scriptVersion="1.5-patched"

SMA_PATH="/config/extended/sma"

if [ -f /config/setup_version.txt ]; then
  # shellcheck disable=SC1091
  source /config/setup_version.txt
  if [ "${scriptVersion}" == "${setupversion:-}" ]; then
    if apk --no-cache list | grep installed | grep opus-tools | read; then
      echo "Setup was previously completed, skipping..."
      exit 0
    fi
  fi
fi
echo "setupversion=$scriptVersion" > /config/setup_version.txt

set -euo pipefail

echo "************ install packages ************" && \
apk add -U --update --no-cache \
  flac \
  opus-tools \
  jq \
  xq \
  git \
  wget \
  mkvtoolnix \
  python3-dev \
  libc-dev \
  py3-pip \
  gcc \
  g++ \
  make \
  build-base \
  cmake \
  ninja \
  llvm20-dev \
  clang20 \
  py3-colorama \
  ffmpeg && \
echo "************ install python packages ************" && \
pip install --upgrade --no-cache-dir -U --break-system-packages \
  excludarr \
  yt-dlp \
  yq && \
echo "************ setup SMA ************"
if [ -d "${SMA_PATH}" ]; then
  rm -rf "${SMA_PATH}"
fi
echo "************ setup directory ************" && \
mkdir -p ${SMA_PATH} && \
echo "************ download repo ************" && \
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git ${SMA_PATH} && \
mkdir -p ${SMA_PATH}/config && \
echo "************ create logging file ************" && \
touch ${SMA_PATH}/config/sma.log && \
chgrp users ${SMA_PATH}/config/sma.log && \
chmod g+w ${SMA_PATH}/config/sma.log && \
echo "************ install pip dependencies ************" && \
python3 -m pip install --break-system-packages --upgrade pip && \
pip3 install --break-system-packages -r ${SMA_PATH}/setup/requirements.txt && \
echo "************ install recyclarr ************" && \
mkdir -p /recyclarr && \
architecture=$(uname -m)
if [[ "$architecture" == arm* ]]; then
  recyclarr_url="https://github.com/recyclarr/recyclarr/releases/latest/download/recyclarr-linux-musl-arm.tar.xz"
elif [[ "$architecture" == "aarch64" ]]; then
  recyclarr_url="https://github.com/recyclarr/recyclarr/releases/latest/download/recyclarr-linux-musl-arm64.tar.xz"
else
  recyclarr_url="https://github.com/recyclarr/recyclarr/releases/latest/download/recyclarr-linux-musl-x64.tar.xz"
fi
wget "$recyclarr_url" -O "/recyclarr/recyclarr.tar.xz" && \
tar -xf /recyclarr/recyclarr.tar.xz -C /recyclarr &>/dev/null && \
chmod 777 /recyclarr/recyclarr
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community dotnet9-runtime

mkdir -p /custom-services.d
parallel ::: \
  'echo "Download QueueCleaner service..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/universal/services/QueueCleaner -o /custom-services.d/QueueCleaner && echo "Done"' \
  'echo "Download AutoConfig service..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/AutoConfig.service -o /custom-services.d/AutoConfig && echo "Done"' \
  'echo "Download AutoExtras service..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/AutoExtras.service -o /custom-services.d/AutoExtras && echo "Done"' \
  'echo "Download InvalidSeriesAutoCleaner service..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/InvalidSeriesAutoCleaner.service -o /custom-services.d/InvalidSeriesAutoCleaner && echo "Done"' \
  'echo "Download YoutubeSeriesDownloader service..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/YoutubeSeriesDownloader.service -o /custom-services.d/YoutubeSeriesDownloader && echo "Done"' \
  'echo "Download Recyclarr service..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/universal/services/Recyclarr -o /custom-services.d/Recyclarr && echo "Done"'

mkdir -p /config/extended
echo "Download Script Functions..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/universal/functions.bash -o /config/extended/functions && echo "Done"

if [ ! -f /config/extended/naming.json ]; then
  echo "Download Naming script..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/naming.json -o /config/extended/naming.json && echo "Done"
fi

echo "Download PlexNotify script..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/PlexNotify.bash -o /config/extended/PlexNotify.bash && echo "Done"
echo "Download DailySeriesEpisodeTrimmer script..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/DailySeriesEpisodeTrimmer.bash -o /config/extended/DailySeriesEpisodeTrimmer.bash && echo "Done"
echo "Download Extras script..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/Extras.bash -o /config/extended/Extras.bash && echo "Done"
echo "Download TdarrScan script..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/TdarrScan.bash -o /config/extended/TdarrScan.bash && echo "Done"

if [ ! -f /config/extended/sma.ini ]; then
  echo "Download SMA config..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/sma.ini -o /config/extended/sma.ini && echo "Done"
fi

if [ ! -f /config/extended/recyclarr.yaml ]; then
  echo "Download Recyclarr config..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/recyclarr.yaml -o /config/extended/recyclarr.yaml && echo "Done"
fi

if [ ! -f /config/extended.conf ]; then
  echo "Download Extended config..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/extended.conf -o /config/extended.conf && echo "Done"
fi

echo "Download UnmappedFolderCleaner service..." && curl -sfL https://raw.githubusercontent.com/RandomNinjaAtk/arr-scripts/main/sonarr/UnmappedFolderCleaner.bash -o /custom-services.d/UnmappedFolderCleaner && echo "Done"

# === ROOT FIX: Robust XML parser for getArrAppInfo ===
cat <<'EOFFUNC' >> /config/extended/functions

getArrAppInfo () {
  if [ -z "${arrUrl:-}" ] || [ -z "${arrApiKey:-}" ]; then
    readarray -t _arrvals < <(python3 - <<'PYARR'
import xml.etree.ElementTree as ET
cfg='/config/config.xml'
try:
    root = ET.parse(cfg).getroot()
except Exception:
    print('')
    print('')
    print('')
    print('')
    raise SystemExit(0)

def t(name):
    v = root.findtext(name, '')
    return '' if v is None else v.strip()

print(t('UrlBase'))
print(t('InstanceName'))
print(t('ApiKey'))
print(t('Port'))
PYARR
)
    arrUrlBase="${_arrvals[0]}"
    arrName="${_arrvals[1]}"
    arrApiKey="${_arrvals[2]}"
    arrPort="${_arrvals[3]}"

    if [ -z "${arrUrlBase}" ]; then
      arrUrlBase=""
    else
      arrUrlBase="/$(echo "${arrUrlBase}" | sed 's#^/*##;s#/*$##')"
    fi

    arrUrl="http://127.0.0.1:${arrPort}${arrUrlBase}"
  fi
}
EOFFUNC

# Safe permissions
chown -R abc:users /config/extended /custom-services.d 2>/dev/null || true
chmod 2775 /config/extended /custom-services.d 2>/dev/null || true
mkdir -p /config/extended/import /config/extended/downloads /config/extended/cache /config/extended/logs
chmod 2775 /config/extended/import /config/extended/downloads /config/extended/cache /config/extended/logs 2>/dev/null || true

find /config/extended -maxdepth 1 -type f -exec chmod 664 {} \; 2>/dev/null || true
find /config/extended -maxdepth 1 -type f -name "*.bash" -exec chmod 775 {} \; 2>/dev/null || true
find /custom-services.d -maxdepth 1 -type f -exec chmod 775 {} \; 2>/dev/null || true

chmod 664 /config/extended.conf 2>/dev/null || true

if [ -f /custom-services.d/scripts_init.bash ]; then
   # user misconfiguration detected, sleeping...
   sleep infinity
fi
exit 0
