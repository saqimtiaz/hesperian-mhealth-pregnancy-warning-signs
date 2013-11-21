#!/bin/sh

make gapbuild LOCALIZATION=en
make gapbuild LOCALIZATION=en VARIANT=-android
make gapbuild LOCALIZATION=es

make gapcommit LOCALIZATION=en
make gapcommit LOCALIZATION=en VARIANT=-android
make gapcommit LOCALIZATION=es

