#! /bin/sh

cd "$(dirname "$0")/.."

bundle exec pod spec lint Toasty.podspec --allow-warnings
