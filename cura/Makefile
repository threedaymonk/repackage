package = cura
version = $(shell curl -sI 'https://github.com/Ultimaker/Cura/releases/latest' \
	  | grep -i '^location:' | grep -Eo '[^/v]+$$')
appimage_url = https://github.com/Ultimaker/Cura/releases/download/$(version)/UltiMaker-Cura-$(version)-linux.AppImage
build_dir = tmp/build-$(version)

.PHONY: deb appimage clean

deb: ../debs/$(package)-$(version).deb

appimage: $(build_dir)/opt/cura/UltiMaker-Cura.AppImage

clean:
	rm -rf "$(build_dir)"

$(build_dir)/opt/cura/UltiMaker-Cura.AppImage:
	mkdir -p $$(dirname "$@")
	curl -Lo "$@" "$(appimage_url)"
	chmod +x "$@"

$(build_dir)/usr/share/icons/hicolor/256x256/apps/cura-icon.png: \
	$(build_dir)/opt/cura/UltiMaker-Cura.AppImage
	mkdir -p $$(dirname "$@")
	7z x -aoa -o"$$(dirname "$@")" "$<" "cura-icon.png"
	touch "$@"

$(build_dir)/usr/share/applications/cura.desktop: \
	$(build_dir)/opt/cura/UltiMaker-Cura.AppImage
	mkdir -p $$(dirname "$@")
	7z x -aoa -o"$$(dirname "$@")" "$<" "cura.desktop"
	touch "$@"

$(build_dir)/DEBIAN/control: control.template
	mkdir -p $$(dirname "$@")
	package="$(package)" version="$(version)" envsubst < $< > $@

../debs/$(package)-$(version).deb: \
	$(build_dir)/opt/cura/UltiMaker-Cura.AppImage \
	$(build_dir)/DEBIAN/control \
	$(build_dir)/usr/share/icons/hicolor/256x256/apps/cura-icon.png \
	$(build_dir)/usr/share/applications/cura.desktop \
	$(wildcard root/**/*)
	cp -R root/* $(build_dir)
	dpkg-deb --root-owner-group --build $(build_dir) $@
