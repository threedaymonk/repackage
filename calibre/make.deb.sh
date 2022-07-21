#!/bin/bash
set -euo pipefail

version="$(curl -s "https://calibre-ebook.com/whats-new" \
  | grep -Eo "Release: [0-9\\.]+" | head -n 1 | cut -d " " -f 2)"
deb="calibre-${version}.deb"

if [ -f "${deb}" ]; then
  echo "Version ${version} has already been packaged"
  exit 0
fi

echo "Configuring version $version"

mkdir -p "build/DEBIAN" "build/opt"

cat <<EOF > build/DEBIAN/control
Package: calibre
Version: ${version}
Section: books
Priority: optional
Architecture: amd64
Maintainer: Paul Battley <pbattley@gmail.com>
Description: Calibre is a free and open-source e-book reader.
EOF

echo "Fetching and running installer script"
curl -LO "https://download.calibre-ebook.com/linux-installer.sh"
sh linux-installer.sh install_dir="build/opt" isolated=y

echo "Extracting app icon"
mkdir -p "build/usr/share/icons/hicolor/256x256/apps"
cp "build/opt/calibre/resources/images/apple-touch-icon.png" \
  "build/usr/share/icons/hicolor/256x256/apps/calibre.png"

echo "Building Calibre package for version $version"
dpkg-deb --root-owner-group --build "build" "${deb}"
