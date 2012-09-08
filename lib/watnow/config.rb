require 'yaml'

module Watnow
  class Config

    FOLDER_IGNORE = %w(tmp node_modules db public log)
    FILE_EXTENSION_IGNORE = %w(tmproj)
    PATTERNS = %w(TODO FIXME)

    def self.options
      @options
    end

    def self.init
      defaults = {
        'color' => true,
        'folder_ignore' => [],
        'file_extension_ignore' => [],
        'patterns' => [],
        'username' => ''
      }

      custom = self.parse_config_file
      @options = defaults.merge(custom)
      @options['folder_ignore'].concat(FOLDER_IGNORE)
      @options['file_extension_ignore'].concat(FILE_EXTENSION_IGNORE)
      @options['patterns'].concat(PATTERNS)
    end

    def self.parse_config_file
      begin
        YAML.load_file("#{ENV['HOME']}/.watnowconfig")
      rescue
        {}
      end
    end

  end
end