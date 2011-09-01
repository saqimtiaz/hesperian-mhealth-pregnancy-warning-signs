# Makefile for creating the hesperian mobile website

.PHONY: all www
BUILD?=0001
ARCHIVE_DIR=./www/archive/${BUILD}

all: www 

www:
	-mkdir -p ${ARCHIVE_DIR}
	cp WhatsNew.txt ${ARCHIVE_DIR}/WhatsNew.txt
	ln -sf ${ARCHIVE_DIR} ./www/latest
	

