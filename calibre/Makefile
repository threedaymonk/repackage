package = calibre
version = $(shell curl -s "https://calibre-ebook.com/whats-new" \
  	  | grep -Eo "Release: [0-9\\.]+" | head -n 1 | cut -d " " -f 2)
build_dir = tmp/build-$(version)

.PHONY: deb installer clean

deb: $(package)-$(version).deb

installer: tmp/linux-installer-$(version).sh

clean:
	rm -rf "$(build_dir)"

tmp/linux-installer-$(version).sh:
	mkdir -p $$(dirname "$@")
	curl -Lo "$@" "https://download.calibre-ebook.com/linux-installer.sh"

$(build_dir)/opt/calibre: tmp/linux-installer-$(version).sh
	mkdir -p $(build_dir)/opt
	sh "$<" install_dir="$(build_dir)/opt" isolated=y

$(build_dir)/usr/share/icons/hicolor/256x256/apps/calibre.png: \
	$(build_dir)/opt/calibre
	mkdir -p $$(dirname "$@")
	cp "$(build_dir)/opt/calibre/resources/images/apple-touch-icon.png" "$@"

$(build_dir)/DEBIAN/control: control.template
	mkdir -p $$(dirname "$@")
	package="$(package)" version="$(version)" envsubst < $< > $@

$(package)-$(version).deb: \
	$(build_dir)/opt/calibre \
	$(build_dir)/DEBIAN/control \
	$(build_dir)/usr/share/icons/hicolor/256x256/apps/calibre.png \
	$(wildcard root/**/*)
	cp -R root/* $(build_dir)
	dpkg-deb --root-owner-group --build $(build_dir) $@
