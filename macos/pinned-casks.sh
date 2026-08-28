#!/bin/bash
#
# Casks that have to stay on an old version.
#
# A Brewfile can't express a cask version, so each of these is installed from
# the homebrew-cask definition as it stood at the commit that shipped that
# version. Paths differ per entry: homebrew-cask only moved casks into letter
# subdirectories in late 2023, and older commits predate that.
#
# All four also update themselves, so turn the in-app updater off right after
# installing or the app climbs back to the latest release on its own.
#
#   ./macos/pinned-casks.sh

set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
    echo "$0: macOS only" >&2
    exit 1
fi

raw="https://raw.githubusercontent.com/Homebrew/homebrew-cask"

# Full 40-character shas: raw.githubusercontent resolves abbreviated ones only
# sometimes, and a miss is a plain 404
#
# --adopt lets brew take over a copy already sitting in /Applications instead
# of refusing because the app exists

# Keyboard Maestro 10.2
brew install --cask --adopt \
    "${raw}/bc779bdfccbd98976bef445edd1fed67559cc977/Casks/keyboard-maestro.rb"

# RunJS 2.9.0
brew install --cask --adopt \
    "${raw}/b2e2e1fb8572d0ed18746dd8cfefba6142be364d/Casks/runjs.rb"

# CleanShot X 4.5.1
brew install --cask --adopt \
    "${raw}/cfa5ab5a9291d080b8c82fd06d28f27b665bf136/Casks/cleanshot.rb"

# WeChat DevTools 1.06.2504060
brew install --cask --adopt \
    "${raw}/ed5c0a6cd290536d982afbeda127fffa96ec4d82/Casks/w/wechatwebdevtools.rb"

echo
echo "Pinned. Turn off each app's own auto-update, or it will move past this."
