require "yaml"

module MakeMeSpiffy
  class InputManifest
    attr_reader :manifest

    def self.from_file(manifest_path)
      file = YAML.load_file(manifest_path)
      self.new(file)
    end

    def initialize(bosh_manifest_yaml)
      @manifest = bosh_manifest_yaml
    end

    # Primary method to replace a chunk of manifest with a (( meta.scope ))
    def spiffy(extraction_scope, meta_scope)
      if value = manifest[extraction_scope]
        manifest[extraction_scope] = "(( #{meta_scope} ))"
        insert_scope_value(meta_scope, "(( merge ))")
      end
      return value
    end

    # Usage: insert_scope_value("meta.foo.bar", 1234)
    # Will add the following into manifest YAML
    #     meta:
    #       foo:
    #         bar: 1234
    def insert_scope_value(meta_scope, value)
      parts = meta_scope.split('.')
      submanifest = manifest
      scoping_parts, key = parts[0..-2], parts[-1]
      for part in scoping_parts
        submanifest[part] ||= {}
        submanifest = submanifest[part]
      end
      submanifest[key] = value
    end
  end
end
