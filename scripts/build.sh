#! /bin/sh

cd "$(dirname "$0")/.."

xcodebuild -project Toasty.xcodeproj  -scheme Toasty -destination 'platform=iOS Simulator,name=iPhone 7' -derivedDataPath='./build' | bundle exec xcpretty && exit ${PIPESTATUS[0]}

