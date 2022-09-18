package = edisyn
version = $(shell curl -s "https://raw.githubusercontent.com/eclab/edisyn/master/README.md" \
  	  | grep -Eo "Version [0-9\\.]+" | head -n 1 | cut -d " " -f 2)
latest_jar_url = https://cs.gmu.edu/~eclab/projects/edisyn/edisyn.jar
build_dir = tmp/build-$(version)

.PHONY: deb jar clean

deb: $(package)-$(version).deb

jar: tmp/edisyn-$(version).jar

clean:
	rm -rf "$(build_dir)"

tmp/edisyn-$(version).jar:
	mkdir -p $$(dirname "$@")
	curl -Lo "$@" "$(latest_jar_url)"

$(build_dir)/DEBIAN/control: control.template
	mkdir -p $$(dirname "$@")
	package="$(package)" version="$(version)" envsubst < $< > $@

$(build_dir)/usr/share/java/edisyn/edisyn.jar: tmp/edisyn-$(version).jar
	mkdir -p $$(dirname "$@")
	cp $< $@

$(package)-$(version).deb: \
	$(build_dir)/usr/share/java/edisyn/edisyn.jar \
	$(build_dir)/DEBIAN/control \
	$(wildcard root/**/*)
	cp -R root/* $(build_dir)
	dpkg-deb --root-owner-group --build $(build_dir) $@
