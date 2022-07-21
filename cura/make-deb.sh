#!/bin/bash
set -euo pipefail

version="$(curl -s "https://ultimaker.com/software/ultimaker-cura" \
  | grep -Eo "VERSION [0-9\\.]+" | head -n 1 | cut -d " " -f 2)"
url="https://github.com/Ultimaker/Cura/releases/download/${version}/Ultimaker-Cura-${version}-linux.Appimage"
appimage_path="build/opt/cura/Ultimaker-Cura.Appimage"
deb="cura-${version}.deb"

if [ -f "${deb}" ]; then
  echo "Version ${version} has already been packaged"
  exit 0
fi

echo "Configuring version $version"

mkdir -p "build/DEBIAN" "build/opt/cura"

cat <<EOF > build/DEBIAN/control
Package: cura
Version: ${version}
Section: graphics
Priority: optional
Architecture: amd64
Maintainer: Paul Battley <pbattley@gmail.com>
Description: 3D printing software
EOF

echo "Fetching distribution Appimage"
curl -Lo "${appimage_path}" "${url}"
chmod +x "${appimage_path}"

echo "Extracting app icon and desktop file"
mkdir -p "build/usr/share/icons/hicolor/256x256/apps"
7z x -aoa -o"build/usr/share/icons/hicolor/256x256/apps" \
  "${appimage_path}" "cura-icon.png"
mkdir -p "build/usr/share/applications"
7z x -aoa -o"build/usr/share/applications" \
  "${appimage_path}" "cura.desktop"

echo "Building Cura package for version $version"
dpkg-deb --root-owner-group --build "build" "${deb}"
