package = orcaslicer
version = $(shell curl -sI 'https://github.com/SoftFever/OrcaSlicer/releases/latest' \
	  | grep -i '^location:' | grep -Eo '[^/v]+$$')
appimage_url = https://github.com/SoftFever/OrcaSlicer/releases/download/v$(version)/OrcaSlicer_Linux_V$(version).AppImage
appimage = $(build_dir)/opt/$(package)/OrcaSlicer.AppImage
build_dir = tmp/build-$(version)

.PHONY: deb appimage clean

deb: ../debs/$(package)-$(version).deb ../debs/$(package)-latest.deb

appimage: $(appimage)

clean:
	rm -rf "$(build_dir)"

$(appimage):
	mkdir -p $$(dirname "$@")
	curl -Lo "$@" "$(appimage_url)"
	chmod +x "$@"

icon_path = usr/share/icons/hicolor/192x192/apps/OrcaSlicer.png
$(build_dir)/$(icon_path): $(appimage)
	mkdir -p $$(dirname "$@")
	7z e -aoa -o"$$(dirname "$@")" "$<" "$(icon_path)"
	touch "$@"

$(build_dir)/DEBIAN/control: control.template
	mkdir -p $$(dirname "$@")
	package="$(package)" version="$(version)" envsubst < $< > $@

../debs/$(package)-latest.deb: ../debs/$(package)-$(version).deb
	ln -sf "$$(readlink -f "$<")" "$@"

../debs/$(package)-$(version).deb: \
	$(appimage) \
	$(build_dir)/DEBIAN/control \
	$(build_dir)/$(icon_path) \
	$(wildcard root/**/*)
	cp -R root/* $(build_dir)
	dpkg-deb --root-owner-group --build $(build_dir) $@
