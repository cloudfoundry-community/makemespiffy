require "yaml"

module MakeMeSpiffy
  class SpiffParam
    def initialize(key)
      @key = key
    end
    def to_s
      "(( #{@key} ))"
    end
    def encode_with(coder)
      coder.tag = "!x"
      coder.style = Psych::Nodes::Mapping::FLOW

      # coder.type = ":scalar"
      coder.scalar = to_s
    end
  end

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
        manifest[extraction_scope] = SpiffParam.new(meta_scope)
        insert_meta_scope(meta_scope, value)
      end
      return value
    end

    private
    # Usage: insert_meta_scope("meta.foo.bar", 1234)
    # Will add the following into manifest YAML
    #     meta:
    #       foo:
    #         bar: 1234
    def insert_meta_scope(meta_scope, value)
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
