package = joplin
version = $(shell curl -sI 'https://github.com/laurent22/joplin/releases/latest' \
	  | grep -i '^location:' | grep -Eo '[^/v]+$$')
appimage_url = https://github.com/laurent22/joplin/releases/download/v$(version)/Joplin-$(version).AppImage
build_dir = tmp/build-$(version)

.PHONY: deb appimage clean

deb: ../debs/$(package)-$(version).deb ../debs/$(package)-latest.deb

appimage: $(build_dir)/opt/joplin/Joplin.AppImage

clean:
	rm -rf "$(build_dir)"

$(build_dir)/opt/joplin/Joplin.AppImage:
	mkdir -p $$(dirname "$@")
	curl -Lo "$@" "$(appimage_url)"
	chmod +x "$@"

$(build_dir)/usr/share/icons/hicolor/512x512/apps/joplin.png:
	mkdir -p $$(dirname "$@")
	curl -L -o "$@" https://joplinapp.org/images/Icon512.png 

$(build_dir)/DEBIAN/control: control.template
	mkdir -p $$(dirname "$@")
	package="$(package)" version="$(version)" envsubst < $< > $@

../debs/$(package)-latest.deb: ../debs/$(package)-$(version).deb
	ln -sf "$$(readlink -f "$<")" "$@"

../debs/$(package)-$(version).deb: \
	$(build_dir)/opt/joplin/Joplin.AppImage \
	$(build_dir)/DEBIAN/control \
	$(build_dir)/usr/share/icons/hicolor/512x512/apps/joplin.png \
	$(wildcard root/**/*)
	cp -R root/* $(build_dir)
	dpkg-deb --root-owner-group --build $(build_dir) $@
