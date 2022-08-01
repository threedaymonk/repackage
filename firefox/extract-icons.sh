#!/bin/bash
set -euo pipefail

for f in $(ls "${build_dir}/opt/firefox/browser/chrome/icons/default/"); do
  size="$(echo $f | grep -Eo '[0-9]+')"
  mkdir -p "${build_dir}/usr/share/icons/hicolor/${size}x${size}/apps"
  cp "${build_dir}/opt/firefox/browser/chrome/icons/default/$f" \
     "${build_dir}/usr/share/icons/hicolor/${size}x${size}/apps/firefox.png"
done
