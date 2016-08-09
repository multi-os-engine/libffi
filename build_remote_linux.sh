#!/bin/bash

# REQUIREMENTS
# sudo apt-get install dh-autoreconf
# sudo apt-get install texinfo

set -e

cd "${0%/*}"

TIME=$(date "+%Y%m%d-%H%M%S")
BUILD_ROOT=build-jobs/libffi
BUILD_DIR=$BUILD_ROOT/$TIME

if [ $# -ne 2 ]; then
	echo "Parameters: <user>@<server> <i686|x86_64>"
	exit 1
fi

REMOTE=$1
ARCH=$2
trap 'echo "ERROR: ${FAIL_MESSAGE}"' ERR

echo "Checking architecture"
export FAIL_MESSAGE="Remote system is not $ARCH!"
if [ $ARCH == "i686" ]; then
	ssh $REMOTE '[ $(uname -i | grep i686 | wc -l) -eq 1 ]'
elif [ $ARCH == "x86_64" ]; then
	ssh $REMOTE '[ $(uname -i | grep x86_64 | wc -l) -eq 1 ]'
else
	echo "ERROR: Unsupported architecture! Supported: i686, x86_64"
	exit 1
fi

export FAIL_MESSAGE="Failed to create build directory!"
ssh $REMOTE "mkdir -p $BUILD_DIR"
ssh $REMOTE "if [ -L $BUILD_ROOT/latest ]; then rm $BUILD_ROOT/latest; fi"
ssh $REMOTE "cd $BUILD_ROOT && ln -s $TIME latest"

export FAIL_MESSAGE="Failed to copy file to remote!"
rsync -av --exclude '.git' . $REMOTE:$BUILD_DIR

export FAIL_MESSAGE="Failed to build on remote!"
ssh $REMOTE "cd $BUILD_DIR && ./autogen.sh"
ssh $REMOTE "cd $BUILD_DIR && ./configure --with-pic=yes"
ssh $REMOTE "cd $BUILD_DIR && make"

export FAIL_MESSAGE="Failed to copy build results from remote!"
if [ $ARCH == "i686" ]; then
	if [ -d i686-pc-linux-gnu ]; then rm -rf i686-pc-linux-gnu; fi
	scp -r $REMOTE:$BUILD_DIR/i686-pc-linux-gnu ./
elif [ $ARCH == "x86_64" ]; then
	if [ -d x86_64-unknown-linux-gnu ]; then rm -rf x86_64-unknown-linux-gnu; fi
	scp -r $REMOTE:$BUILD_DIR/x86_64-unknown-linux-gnu ./
else
	echo "ERROR: Unsupported architecture! Supported: i686, x86_64"
	exit 1
fi
