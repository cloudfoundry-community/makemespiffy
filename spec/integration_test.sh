#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

set -e

source_manifest=${source_manifest:-spec/fixtures/concourse.yml}
manifest=tmp/manifest.yml

rm -rf tmp
mkdir -p tmp
cp ${source_manifest} tmp/manifest.yml

bundle exec bin/makemespiffy ${manifest} name tmp/name.yml meta.name
bundle exec bin/makemespiffy ${manifest} director_uuid tmp/director.yml meta.director_uuid
bundle exec bin/makemespiffy ${manifest} releases tmp/stub.yml meta.releases
bundle exec bin/makemespiffy ${manifest} resource_pools.concourse.stemcell tmp/stub.yml meta.stemcell

spiff merge tmp/manifest.yml tmp/name.yml tmp/director.yml tmp/stub.yml > tmp/spiffy.yml
spiff diff ${source_manifest} tmp/spiffy.yml
