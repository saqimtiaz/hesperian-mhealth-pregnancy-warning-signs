CONFIGURATION=Ad Hoc
APPLICATION_NAME=Safe-Pregnancy-and-Birth
RELEASE_BUILDDIR= ./build/$(CONFIGURATION)-iphoneos
#DEVELOPER_NAME=Matthew Litwin (763465CPK9)
SIGNING_IDENTITY=iPhone Distribution: Matthew Litwin
#PROVISONING_PROFILE=HesperianMobileTest.mobileprovision
PROVISONING_PROFILE=RamonaStreetAdHoc.mobileprovision
PWD=$(shell pwd)
OUTDIR?=output
BUILD?=0dev


.PHONY: testbuild ipa

all: testbuild

setbuild:
	agvtool -noscm new-version -all 1.0.$(shell echo $(BUILD) | sed -e 's/^0*//' )

testbuild: setbuild
	xcodebuild -configuration "$(CONFIGURATION)" build
	 /usr/bin/xcrun -no-cache -sdk iphoneos PackageApplication -v "$(RELEASE_BUILDDIR)/$(APPLICATION_NAME).app" -o "$(PWD)/$(APPLICATION_NAME).ipa" --sign "$(SIGNING_IDENTITY)" --embed "$(PROVISONING_PROFILE)"
	@echo "Created $(APPLICATION_NAME).ipa"

clean:
	-rm -r build/ "$(APPLICATION_NAME).ipa"

release:
	make clean;
	make testbuild
	mkdir -p $(OUTDIR)
	cp "$(APPLICATION_NAME).ipa" $(OUTDIR)
	
