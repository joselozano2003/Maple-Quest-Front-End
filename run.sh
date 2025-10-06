#!/bin/bash
set -e

DEVICE="iPhone 16"
SCHEME="Maple-Quest"
BUNDLE_ID="com.yourcompany.Maple-Quest"

xcrun simctl boot "$DEVICE" || true
open -a Simulator

xcodebuild -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,name=$DEVICE" \
  -configuration Debug \
  build

xcrun simctl install booted "build/Debug-iphonesimulator/$SCHEME.app"
xcrun simctl launch booted "$BUNDLE_ID"
