require 'optparse'

module Watnow
  class OptParser

    def self.parse(args)
      # Defaults
      options = {}
      options[:directory] = '.'

      opts = OptionParser.new('', 24, '  ') do |opts|
        opts.separator '  Usage: watnow [options]'
        opts.separator ''

        # Help
        opts.on('-h', '--help', 'show this message') do
          puts opts
          exit
        end

        # Version
        opts.on('-v', '--version', 'display version') do
          puts 'version here'
        end

        # Directory
        opts.on('-d', '--directory DIR', 'directory DIR to scan (defaults: ./)') do |d|
          options[:directory] = d
        end

      end

      opts.parse!(args)
      options
    end

  end
end