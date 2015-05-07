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
  end
end
