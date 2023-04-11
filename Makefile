MAKEFLAGS += -j4

.PHONY: all

all: calibre cura edisyn firefox joplin neovim

debs:
	mkdir -p debs

%: debs
	$(MAKE) -C $@
