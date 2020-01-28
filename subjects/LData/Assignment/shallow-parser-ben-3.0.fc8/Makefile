#
# Makefile -- compiling/copying/install/uninstall the bendi shallow parser
#

PREFIX = ${SHALLOW_PARSER_BEN}

# Program files and directories.
DEST_PROG_BIN_DIR = $(PREFIX)

# Programs and Data files/directories.
MODULE_BIN_DIR = ${PWD}

# make all -- make programs, data, library, documentation, etc.

all:

# make install -- Install the bendi shallow parser in '/usr/local/' directory, 
install:
	mkdir -p $(DEST_PROG_BIN_DIR)/bin
	cp -fr $(MODULE_BIN_DIR)/* $(DEST_PROG_BIN_DIR)
	ln -fs $(DEST_PROG_BIN_DIR)/bin/sys/ben/shallow_parser_ben.pl ${SHALLOW_PARSER_BEN}/bin/sys/ben/shallow_parser_ben
	sh crf_install.sh
	sh test.sh

# make compile -- Compiles the source code as well as the data
# compile: compile-exec compile-data

# remove the module files from sampark
clean:uninstall
uninstall:
	rm -fr ${SHALLOW_PARSER_BEN}/

.PHONY: all clean install uninstall 

