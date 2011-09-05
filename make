#!/bin/bash
#
# simple script that makes 2 artifacts
# - tklpatch tar.gz file
# - installable iso image
#


BASEAPP=lamp
TKLVER=11.2-lucid-x86
BASE=turnkey-$BASEAPP-$TKLVER
BASEISO=$BASE.iso
TARGET=turnkey-newznabbapp-11.2-lucid-x86.iso

if [ -d build ]; then
   rm -rf build
fi

# see if we already have the base iso image
if [ ! -f "iso/${BASEISO}" ]; then

   # make the iso directory if we need to
   if [ ! -d iso ]; then
      mkdir iso
   fi

   # get the base iso image
   wget -P iso http://downloads.sourceforge.net/project/turnkeylinux/turnkey-$BASEAPP/$TKLVER/$BASEISO
fi

if [ ! -d build ]; then
   # make the build target directory
   mkdir build
fi

# cd into the build directory
cd build

# run tklpatch
tklpatch-bundle ../tklpatch/newznabapp
tklpatch ../iso/$BASEISO ../tklpatch/newznabapp
mv $BASE-patched.iso $TARGET



