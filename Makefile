MAKEFLAGS += -j4

.PHONY: all

all: calibre cura edisyn firefox joplin

debs:
	mkdir -p debs

%: debs
	$(MAKE) -C $@
