package = firefox-mozilla-central
os = linux64
lang = en-GB
tarball_url = https://download.mozilla.org/?product=firefox-latest-ssl&os=$(os)&lang=$(lang)
desktop_url = https://hg.mozilla.org/mozilla-central/raw-file/tip/browser/components/shell/search-provider-files/firefox.desktop
version = $(shell curl -sD - "$(tarball_url)" | grep Location \
	  | grep -Eo "releases/[0-9\\.]+" | cut -d'/' -f2)
build_dir = tmp/build-$(version)

.PHONY: deb tarball clean

deb: ../debs/$(package)-$(version).deb

tarball: tmp/firefox-$(version).tar.bz2

clean:
	rm -rf "$(build_dir)"

$(build_dir)/usr/share/applications/firefox.desktop:
	mkdir -p $$(dirname "$@")
	curl -Lo "$@" "$(desktop_url)"

tmp/firefox-$(version).tar.bz2:
	mkdir -p $$(dirname "$@")
	curl -Lo "$@" "$(tarball_url)"

$(build_dir)/DEBIAN/control: control.template
	mkdir -p $$(dirname "$@")
	package="$(package)" version="$(version)" envsubst < $< > $@

$(build_dir)/opt/firefox: tmp/firefox-$(version).tar.bz2
	mkdir -p $(build_dir)/opt
	tar -C $(build_dir)/opt -jxvf tmp/firefox-$(version).tar.bz2

../debs/$(package)-$(version).deb: \
	$(build_dir)/opt/firefox \
	$(build_dir)/DEBIAN/control \
	$(build_dir)/usr/share/applications/firefox.desktop \
	$(wildcard root/**/*)
	cp -R root/* $(build_dir)
	build_dir="$(build_dir)" ./extract-icons.sh
	dpkg-deb --root-owner-group --build $(build_dir) $@
