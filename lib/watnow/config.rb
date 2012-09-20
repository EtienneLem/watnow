require 'yaml'

module Watnow::Config

  # Default constants
  FOLDER_IGNORE = %w(tmp node_modules db public log)
  FILE_EXTENSION_IGNORE = %w(tmproj markdown md txt)
  PATTERNS = %w(TODO FIXME)

  def self.included(base)
    defaults = {
      'color' => true,
      'folder_ignore' => [],
      'file_extension_ignore' => [],
      'patterns' => [],
      'username' => ''
    }

    # Parse YAML config file (~/.watnowconfig)
    parser = YamlParser.new
    custom_options = parser.parse

    # Merge defaults with custom options
    # Add default constants
    options = custom_options ? defaults.merge(custom_options) : defaults
    options['folder_ignore'].concat(FOLDER_IGNORE)
    options['file_extension_ignore'].concat(FILE_EXTENSION_IGNORE)
    options['patterns'].concat(PATTERNS)

    # Generate singleton methods with options keys for quick access
    # i.e. self.color, self.patterns, self.username, etc
    options.each do |option|
      define_singleton_method option[0] do
        option[1]
      end
    end
  end

  # Simple YAML parser
  # Returns empty object if no file found
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