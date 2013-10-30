#!/bin/sh
# Generate Android key for hesperian apps.
# http://developer.android.com/tools/publishing/app-signing.html

KEYNAME=SafeBirth-en
ALIAS=SB-en
DNAME="CN=hesperian.org,O=Hesperian Health Guides,OU=Digital,L=Berkeley,ST=CA,C=US"

keytool -genkey -v\
 -keystore ${KEYNAME}.keystore\
 -alias ${ALIAS}\
 -keyalg RSA\
 -keysize 2048\
 -dname "${DNAME}"\
 -validity 999999
