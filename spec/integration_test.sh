#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

set -e

source_manifest=${source_manifest:-spec/fixtures/concourse.yml}

rm -rf tmp
mkdir -p tmp
cp ${source_manifest} tmp/manifest.yml

bundle exec bin/makemespiffy tmp/manifest.yml name tmp/name.yml meta.name

spiff merge tmp/manifest.yml tmp/name.yml > tmp/spiffy.yml
spiff diff ${source_manifest} tmp/spiffy.yml
