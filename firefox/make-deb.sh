#!/bin/bash
set -euo pipefail

os="linux64"
lang="en-GB"
url="https://download.mozilla.org/?product=firefox-latest-ssl&os=${os}&lang=${lang}"
desktop_url="https://hg.mozilla.org/mozilla-central/raw-file/tip/browser/components/shell/search-provider-files/firefox.desktop"

version="$(curl -sD - "${url}" | grep Location \
  | grep -Eo "releases/[0-9\\.]+" | cut -d'/' -f2)"

echo "Configuring version $version"

mkdir -p "build/DEBIAN" "build/opt"

cat <<EOF > build/DEBIAN/control
Package: firefox
Version: ${version}
Section: web
Priority: optional
Architecture: amd64
Maintainer: Paul Battley <pbattley@gmail.com>
Description: Firefox Web Browser (from Mozilla tarball)
EOF

echo "Fetching and expanding distribution tarball"

curl -sL "${url}" | tar -C "build/opt" -jxv

echo "Assembling desktop icons"

for f in $(ls "build/opt/firefox/browser/chrome/icons/default/"); do
  size="$(echo $f | grep -Eo '[0-9]+')"
  mkdir -p "build/usr/share/icons/hicolor/${size}x${size}/apps"
  cp "build/opt/firefox/browser/chrome/icons/default/$f" \
    "build/usr/share/icons/hicolor/${size}x${size}/apps/firefox.png"
done

echo "Fetching desktop file for launcher"

mkdir -p "build/usr/share/applications"
curl -sLo "build/usr/share/applications/firefox.desktop" "${desktop_url}"

echo "Building Firefox package for version $version"
dpkg-deb --root-owner-group --build "build" "firefox-${version}.deb"
