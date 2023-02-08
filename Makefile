MAKEFLAGS += -j4

.PHONY: all

all: calibre cura edisyn firefox joplin

debs:
	mkdir -p debs

calibre: debs
	$(MAKE) -C calibre

cura: debs
	$(MAKE) -C cura

edisyn: debs
	$(MAKE) -C edisyn

firefox: debs
	$(MAKE) -C firefox

joplin: debs
	$(MAKE) -C joplin
