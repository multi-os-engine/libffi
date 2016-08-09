#!/bin/bash

./autogen.sh

python generate-darwin-source-and-headers.py

xcodebuild -target libffi-Mac-static -configuration Release -sdk macosx
xcodebuild -target libffi-Mac-static -configuration Debug -sdk macosx
xcodebuild -target libffi-iOS -configuration Release -sdk iphoneos
xcodebuild -target libffi-iOS -configuration Debug -sdk iphoneos
xcodebuild -target libffi-iOS -configuration Release -sdk iphonesimulator
xcodebuild -target libffi-iOS -configuration Debug -sdk iphonesimulator
