require "yaml"

module MakeMeSpiffy
  class InputManifest
    attr_reader :manifest

    class UnknownScopeError < Exception; end

    def self.from_file(manifest_path)
      file = YAML.load_file(manifest_path)
      self.new(file)
    end

    def initialize(bosh_manifest_yaml)
      @manifest = bosh_manifest_yaml
    end

    # Primary method to replace a chunk of manifest with a (( meta.scope ))
    def spiffy(extraction_scope, meta_scope)
      part, *other_parts = extraction_scope.split('.')

      if manifest.is_a?(Array)
        part_value = manifest.find { |item| item["name"] == part }
      else
        part_value = manifest[part]
      end

      if other_parts.size == 0
        if part_value
          manifest[extraction_scope] = "(( #{meta_scope} ))"
        end
        return part_value
      else
        unless part_value
          raise UnknownScopeError, extraction_scope
        end
        inner_manifest = InputManifest.new(part_value)
        return inner_manifest.spiffy(other_parts.join("."), meta_scope)
      end
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
