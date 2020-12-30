#!/usr/bin/env bash

set -e

PACKAGE_MANAGER=$1
shift

TEST_CASE=$1
shift

TEST_DIR=$1
shift

HERE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)

cd "$TEST_DIR"

setup-yarn() {
  npm install -g yarn

  yarn init -2y

  echo >>"$TEST_DIR/.yarnrc.yml" \
    "nodeLinker: node-modules"
}

setup-yarn-classic() {
  npm install -g yarn

  yarn init -y
}

setup-npm() {
  npm install -g npm@^7

  npm init -y
}

setup-npm-legacy-peers() {
  setup-npm

  echo >>"$TEST_DIR/.npmrc" \
    "legacy-peer-deps = true"
}

setup-npm-6() {
  npm install -g npm@^6

  npm init -y
}

setup-pnpm() {
  npm install -g pnpm

  pnpm init -y
}

"setup-$PACKAGE_MANAGER"

case $PACKAGE_MANAGER in
yarn | yarn-classic | pnpm)
  $PACKAGE_MANAGER add $TEST_CASE
  ;;
npm | npm-legacy-peers | npm-6)
  $PACKAGE_MANAGER install $TEST_CASE
  ;;
*)
  echo "Invalid package manager $PACKAGE_MANAGER"
  return 1
  ;;
esac

node $HERE_DIR/log-node-modules-structure $TEST_DIR
