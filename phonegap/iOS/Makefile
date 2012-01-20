#CONFIGURATION=Ad Hoc
CONFIGURATION=AppStore
APPLICATION_NAME=Safe-Pregnancy-and-Birth
RELEASE_BUILDDIR= ./build/$(CONFIGURATION)-iphoneos
SIGNING_IDENTITY=iPhone Distribution: The Hesperian Foundation
AD_HOC_PROVISONING_PROFILE=Hesperian_Ad_Hoc_Distribution_Profile.mobileprovision
PWD=$(shell pwd)
OUTDIR?=output
BUILD?=0dev

CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate


.PHONY: build appstore_zip

all: build

setbuild:
	agvtool -noscm new-version -all 1.0.$(shell echo $(BUILD) | sed -e 's/^0*//' )

build: setbuild
	xcodebuild -configuration "$(CONFIGURATION)" clean build

clean:
	-rm -r build/ output/ "$(APPLICATION_NAME).ipa"

release:
	make clean;
	make build
	(cd "$(RELEASE_BUILDDIR)"; zip -y -r "$(APPLICATION_NAME).zip" "$(APPLICATION_NAME).app")
	@echo "Created $(APPLICATION_NAME).zip"
	 /usr/bin/xcrun -no-cache -sdk iphoneos PackageApplication -v "$(RELEASE_BUILDDIR)/$(APPLICATION_NAME).app" -o "$(PWD)/$(APPLICATION_NAME).ipa" --sign "$(SIGNING_IDENTITY)" --embed "$(AD_HOC_PROVISONING_PROFILE)"
	@echo "Created Ad Hoc $(APPLICATION_NAME).ipa"
	mkdir -p $(OUTDIR)
	cp "$(APPLICATION_NAME).ipa" $(OUTDIR)
	cp "$(RELEASE_BUILDDIR)/$(APPLICATION_NAME).zip" $(OUTDIR)
