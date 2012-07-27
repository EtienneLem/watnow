require 'yaml'

module Watnow
  class Config

    IGNORES = %w(tmp node_modules db public log)
    PATTERNS = %w(TODO FIXME)

    def self.options
      @options
    end

    def self.init
      defaults = {
        'color' => true,
        'ignores' => [],
        'patterns' => []
      }

      custom = self.load
      @options = defaults.merge(custom)
      @options['ignores'].concat(IGNORES)
      @options['patterns'].concat(PATTERNS)  
    end

    def self.load
      begin
        YAML.load_file("#{ENV['HOME']}/.watnowconfig")
      rescue
        {}
      end
    end

  end
end