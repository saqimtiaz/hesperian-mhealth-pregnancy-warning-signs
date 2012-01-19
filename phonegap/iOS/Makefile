CONFIGURATION=Ad Hoc
APPLICATION_NAME=Safe-Pregnancy-and-Birth
RELEASE_BUILDDIR= ./build/$(CONFIGURATION)-iphoneos
SIGNING_IDENTITY=iPhone Distribution: The Hesperian Foundation
PROVISONING_PROFILE=Hesperian_Ad_Hoc_Distribution_Profile.mobileprovision
PWD=$(shell pwd)
OUTDIR?=output
BUILD?=0dev


.PHONY: testbuild ipa appstore

all: testbuild

setbuild:
	agvtool -noscm new-version -all 1.0.$(shell echo $(BUILD) | sed -e 's/^0*//' )

testbuild: setbuild
	xcodebuild -configuration "$(CONFIGURATION)" clean build
	 /usr/bin/xcrun -no-cache -sdk iphoneos PackageApplication -v "$(RELEASE_BUILDDIR)/$(APPLICATION_NAME).app" -o "$(PWD)/$(APPLICATION_NAME).ipa" --sign "$(SIGNING_IDENTITY)" --embed "$(PROVISONING_PROFILE)"
	@echo "Created $(APPLICATION_NAME).ipa"

clean:
	-rm -r build/ "$(APPLICATION_NAME).ipa"

appstore_zip: 
	xcodebuild -configuration AppStore clean build
	(cd "$(RELEASE_BUILDDIR)"; zip -y -r "$(APPLICATION_NAME).zip" "$(APPLICATION_NAME).app")
	mkdir -p $(OUTDIR)
	cp "$(RELEASE_BUILDDIR)/$(APPLICATION_NAME).zip" $(OUTDIR)


release:
	make clean;
	make testbuild
	mkdir -p $(OUTDIR)
	cp "$(APPLICATION_NAME).ipa" $(OUTDIR)
