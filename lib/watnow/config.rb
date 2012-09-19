require 'yaml'

module Watnow::Config

  FOLDER_IGNORE = %w(tmp node_modules db public log)
  FILE_EXTENSION_IGNORE = %w(tmproj)
  PATTERNS = %w(TODO FIXME)

  def self.included(base)
    defaults = {
      'color' => true,
      'folder_ignore' => [],
      'file_extension_ignore' => [],
      'patterns' => [],
      'username' => ''
    }

    parser = YamlParser.new
    custom = parser.parse
    options = defaults.merge(custom)
    options['folder_ignore'].concat(FOLDER_IGNORE)
    options['file_extension_ignore'].concat(FILE_EXTENSION_IGNORE)
    options['patterns'].concat(PATTERNS)

    options.each do |option|
      define_singleton_method option[0] do
        option[1]
      end
    end
  end

  class YamlParser
    def parse
      begin
        YAML.load_file("#{ENV['HOME']}/.watnowconfig")
      rescue
        {}
      end
    end
  end

end