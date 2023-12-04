MAKEFLAGS += -j4

.PHONY: all calibre cura edisyn firefox joplin neovim prune

all : calibre cura edisyn firefox joplin neovim

calibre cura edisyn firefox joplin neovim :
	mkdir -p debs
	$(MAKE) -C $@

prune :
	./prune.sh
