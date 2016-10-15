#!/bin/sh

bundle exec jazzy \
  --clean \
  --author Baris Sencan \
  --author_url http://barissencan.com \
  --github_url https://github.com/isair/Toasty \
  --module-version 0.2.0 \
  --xcodebuild-arguments -scheme,Toasty \
  --module Toasty \
  --output docs
