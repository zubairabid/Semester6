SHELL = /bin/sh

PREFIX = $(setu)
#VER = 2.1

SUBDIRS = $(PREFIX)/data_src/sl/morph/ben/shell analyser

.PHONY: $(SUBDIRS)

# Program and Data files and directories.
DEST_BIN_PROG_DIR = $(PREFIX)/bin/sl/morph/ben
DEST_BIN_DATA_DIR = $(PREFIX)/data_bin/sl/morph/ben
CPFR = cp -fr

all:

compile: $(SUBDIRS)

$(SUBDIRS):
	export LANG=C
	$(MAKE) -C $@

install:install-exe install-data
install-exe:
	mkdir -p $(DEST_BIN_PROG_DIR)
	$(CPFR) analyser/morph.out $(DEST_BIN_PROG_DIR)
	$(CPFR) README INSTALL ChangeLog docs tests morph_run.sh morph.sh morph.spec $(DEST_BIN_PROG_DIR)
install-data:
	mkdir -p $(DEST_BIN_DATA_DIR)
	$(CPFR) $(PREFIX)/data_src/sl/morph/ben/dict $(DEST_BIN_DATA_DIR)
clean:
	$(MAKE) -C analyser clean
	rm -fr $(PREFIX)/bin/sl/morph/ben/*
	rm -fr $(PREFIX)/data_bin/sl/morph/ben/*
	rm -fr $(PREFIX)/data_src/sl/morph/ben/*

