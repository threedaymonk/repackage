MAKEFLAGS += -j4

.PHONY: all calibre cura edisyn joplin neovim prune

all : calibre cura edisyn joplin neovim

calibre cura edisyn joplin neovim :
	mkdir -p debs
	$(MAKE) -C $@

prune :
	ruby prune.rb
