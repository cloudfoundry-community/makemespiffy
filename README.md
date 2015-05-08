Make Me Spiffy
==============

Convert a flat BOSH manifest for something into a set of Spiff templates.

This is being developed to help migrate flat BOSH manifests into a standardised Concourse pipeline that could deploy anything.

Usage
-----

Given a BOSH manifest `manifest.yml`, run the command multiple times to extract data into spiff templates:

```
makemespiffy manifest.yml name environment/name.yml meta.name
```

This will take the root level key `name` from `manifest.yml` and replace it with `(( meta.name ))`.

```
name: manifest-name
```

Becomes:

```yaml
meta:
  name: (( merge ))

name: (( meta.name ))
```

It will also create `environment/name.yml` (if not yet created) and add the extracted value:

```yaml
meta:
  name: manifest-name
```

Multiple fields can be extracted into the same target file.

Reference items from lists by their `name:` field (like `spiff` itself does):

```
makemespiffy manifest.yml "jobs.runner_z1.instances" environment/scaling.yml meta.instances.runner_z1
```

Complex objects can be extracted too:

```
makemespiffy manifest.yml "networks.cf1.subnets" environment/networking.yml meta.subnets.cf1
```

Installation
------------

```
gem install makemespiffy
```
