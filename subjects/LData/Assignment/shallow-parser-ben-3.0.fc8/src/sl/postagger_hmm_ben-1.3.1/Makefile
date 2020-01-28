#
# Makefile -- compiling/copying/install/uninstall the module
#

PREFIX = $(setu)

# Program and Data files and directories.
DEST_BIN_PROG_DIR = $(PREFIX)/bin/sl/postagger_ben/
DEST_DATA_BIN_DIR = $(PREFIX)/data_bin/sl/postagger_ben/
CPFR = cp -fr

# make all -- make programs, library, documentation, etc.
all:

install:install-src

install-src:
	mkdir -p $(DEST_BIN_PROG_DIR)
	mkdir -p $(DEST_DATA_BIN_DIR)
	$(CPFR) ChangeLog INSTALL postagger.sh postagger_train.sh  ssf2tnt.pl common doc postagger_run.sh postagger.spec README  tests $(DEST_BIN_PROG_DIR)
	$(CPFR) data_bin/* $(DEST_DATA_BIN_DIR)
# make compile -- Compiles the source code  
# compile: compile-exec

# make install -- Install what all needs to be installed, copying the files from the packages tree to systemwide directories.# it installs the engine and the corpus, dictionary, etc.


# remove the module files from sampark
clean:uninstall
uninstall:
	rm -fr $(DEST_BIN_PROG_DIR) $(DEST_DATA_BIN_DIR)

.PHONY: all clean install uninstall install-src 
