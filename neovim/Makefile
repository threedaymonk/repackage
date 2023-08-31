package = neovim
version = $(shell curl -Ls 'https://github.com/neovim/neovim/releases/latest' \
	  | grep -Eio 'NVIM v[0-9\.]+' | head -n 1 | cut -c 7-)
appimage_url = https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
build_dir = tmp/build-$(version)

.PHONY: deb clean

deb: ../debs/$(package)-$(version).deb ../debs/$(package)-latest.deb

clean:
	rm -rf "$(build_dir)"

$(build_dir)/opt/neovim/neovim.appimage:
	mkdir -p $$(dirname "$@")
	curl -Lo "$@" "$(appimage_url)"
	chmod +x "$@"

$(build_dir)/DEBIAN/control: control.template
	mkdir -p $$(dirname "$@")
	package="$(package)" version="$(version)" envsubst < $< > $@

../debs/$(package)-latest.deb: ../debs/$(package)-$(version).deb
	ln -sf "$$(readlink -f "$<")" "$@"

../debs/$(package)-$(version).deb: \
	$(build_dir)/opt/neovim/neovim.appimage \
	$(build_dir)/DEBIAN/control \
	$(wildcard root/**/*)
	cp -R root/* $(build_dir)
	dpkg-deb --root-owner-group --build $(build_dir) $@
