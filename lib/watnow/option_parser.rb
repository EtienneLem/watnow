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
          puts VERSION
          exit
        end

        # Directory
        opts.on('-d', '--directory DIR', 'directory DIR to scan (defaults: ./)') do |d|
          options[:directory] = d
        end

        # Commands
        opts.separator ''
        opts.separator '  watnow commands:'
        opts.separator '  open <ID>    open annotation ID in your editor'
        opts.separator '  remove <ID>  remove annotation ID'

        options[:open] = get_option_value('open', args)
        options[:remove] = get_option_value('remove', args)

      end

      opts.parse!(args)
      options
    end

    private

    def self.get_option_value(option, args)
      args.include?(option) ? args[args.index(option) + 1] : nil
    end

  end
end