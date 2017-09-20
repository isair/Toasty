#! /bin/sh

cd "$(dirname "$0")/.."

bundle exec pod trunk push Toasty.podspec
