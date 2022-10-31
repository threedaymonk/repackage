.PHONY: debs

debs:
	mkdir -p debs
	for f in $$(ls */Makefile); do make -C $$(dirname $$f); done
