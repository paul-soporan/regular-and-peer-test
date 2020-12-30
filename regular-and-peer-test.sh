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

test-yarn() {
  npm install -g yarn

  yarn init -2y

  echo >>"$TEST_DIR/.yarnrc.yml" \
    "nodeLinker: node-modules"

  yarn add $TEST_CASE
}

test-yarn-classic() {
  npm install -g yarn

  yarn init -y

  yarn add $TEST_CASE
}

test-npm() {
  npm install -g npm@^7

  npm init -y

  npm install $TEST_CASE
}

test-npm-legacy-peers() {
  echo >>"$TEST_DIR/.npmrc" \
    "legacy-peer-deps = true"

  test-npm
}

test-npm-6() {
  npm install -g npm@^6

  npm init -y

  npm install $TEST_CASE
}

test-pnpm() {
  npm install -g pnpm

  pnpm init -y

  pnpm add $TEST_CASE
}

"test-$PACKAGE_MANAGER"

node $HERE_DIR/log-node-modules-structure $TEST_DIR
