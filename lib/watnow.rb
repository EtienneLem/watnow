require 'watnow/version'
require 'watnow/option_parser'

module Watnow
  class Extractor

    IGNORES = %w(tmp node_modules db public log)

    def initialize
      options = Watnow::OptParser.parse(ARGV)
      scan options[:directory]
    end

    private

    def scan(dir)
      result = []

      Dir.glob("#{dir}/*") do |path|
        next if File.basename(path) =~ /(#{IGNORES.join('|')})$/

        if File.directory? path
          scan path
        else
          begin
            comment_closing_tags = %w(\*\/ -->)
            content = read_file(path, /(TODO|FIXME):?\s*(.*)/)
            result << content if content
          rescue
            nil
          end
        end
      end

      result.each do |annotation|
        puts annotation
      end
    end

    def read_file(file, pattern)
      lineno = 0
      result = File.readlines(file).inject([]) do |list, line|
        lineno += 1
        next list unless line =~ pattern
        list << { :lineno => lineno, :tag => $1, :line => $2.gsub(/\s*(\*\/|-->)$/, '') }
      end
      result.empty? ? nil : { file => result }
    end

  end
end
