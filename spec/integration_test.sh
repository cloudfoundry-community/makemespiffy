#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

set -e

source_manifest=${source_manifest:-spec/fixtures/concourse.yml}
manifest=tmp/manifest.yml
makemespiffy() {
  bundle exec bin/makemespiffy $@
}

rm -rf tmp
mkdir -p tmp
cp ${source_manifest} tmp/manifest.yml

makemespiffy ${manifest} name tmp/name.yml meta.name
makemespiffy ${manifest} director_uuid tmp/director.yml meta.director_uuid
makemespiffy ${manifest} releases tmp/stub.yml meta.releases
makemespiffy ${manifest} resource_pools.concourse.stemcell tmp/stub.yml meta.stemcell
makemespiffy ${manifest} networks.concourse.subnets tmp/networks.yml meta.subnets
makemespiffy ${manifest} jobs.web.instances tmp/scaling.yml meta.instances.web
makemespiffy ${manifest} jobs.worker.instances tmp/scaling.yml meta.instances.worker

spiff merge tmp/manifest.yml tmp/networks.yml tmp/scaling.yml tmp/name.yml tmp/director.yml tmp/stub.yml > tmp/spiffy.yml
spiff diff ${source_manifest} tmp/spiffy.yml
