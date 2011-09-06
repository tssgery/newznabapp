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
VER=`date +"%Y%m%d"`
TARGET="turnkey-newznabapp-11.2-lucid-x86.iso"
PTARGET="newznabapp.tar.gz"

if [ $# -eq 1 ]; then
   TAG=$1
   echo "A tag comment must be supplied, please enter it here:"
   read COMMENT
elif [ $# -eq 2 ]; then
   TAG=$1
   COMMENT=$2
elif [ $# -gt 2 ]; then
   echo "Error, only 2 arguments are supported. That tag name and comment"
   exit 1
fi

if [ $# -gt 0 ]; then
   git tag -a "${TAG}" -m "${COMMENT}"
   # tag the code and set the variable names
   TARGET="turnkey-newznab-11.2-lucid-x86-$TAG.iso"
   PTARGET="newznabapp-$TAG.tar.gz"
fi


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
mv newznabapp.tar.gz $PTARGET
tklpatch ../iso/$BASEISO ../tklpatch/newznabapp
mv $BASE-patched.iso $TARGET



