require "yaml"

module MakeMeSpiffy
  class OutputTemplateManifest
    attr_reader :manifest

    def self.from_file(manifest_path)
      if File.exist?(manifest_path)
        file = YAML.load_file(manifest_path)
      else
        file = {}
      end
      self.new(file)
    end

    def initialize(bosh_manifest_yaml)
      @manifest = bosh_manifest_yaml
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
