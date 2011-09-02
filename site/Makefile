# Makefile for creating the hesperian mobile development website

.PHONY: all www deploy-www deploy
BUILD?=0001
ARCHIVE_DIR=./www/archive/${BUILD}

all: www 

# The main www target creates the archive directory, and seeds it with the
# WhatsNew.txt file. Creation of content / phonegap builds are the
# responsibility of higher level Makefiles
www:
	-mkdir -p ${ARCHIVE_DIR}
	cp ../WhatsNew.txt ${ARCHIVE_DIR}/WhatsNew.txt
	ln -sf ${ARCHIVE_DIR} ./www/latest

# Push the website live.
deploy:
	hm-site-rsync.sh
