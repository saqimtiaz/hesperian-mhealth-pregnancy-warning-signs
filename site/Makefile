# Makefile for creating the hesperian mobile development website

BUILD ?= 0001
ARCHIVE_DIR_BASE=archive/${BUILD}
ARCHIVE_DIR=./www/$(ARCHIVE_DIR_BASE)

.PHONY: all www deploy-www deploy

all: www 

# The main www target creates the archive directory, and seeds it with the
# WhatsNew.txt file. Creation of content / phonegap builds are the
# responsibility of higher level Makefiles
www:
	-mkdir -p ${ARCHIVE_DIR}
	cp ../WhatsNew.txt ${ARCHIVE_DIR}/WhatsNew.txt
	(cd www; rm -f latest; ln -sf ${ARCHIVE_DIR_BASE} latest)

# Push the website live.
deploy:
	hm-site-rsync.sh
