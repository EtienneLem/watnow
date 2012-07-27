require 'watnow/version'
require 'watnow/option_parser'
require 'watnow/annotation/annotation'
require 'watnow/annotation/annotation_line'

module Watnow
  class Extractor

    IGNORES = %w(tmp node_modules db public log)

    def initialize
      options = OptParser.parse(ARGV)

      scan(options[:directory])

      if options[:open]
        id = Integer(options[:open])
        annotation_line = AnnotationLine.find(id)
        open_file_at_line(annotation_line.annotation.file, annotation_line.lineno)
      elsif options[:close]
        puts "close up #{options[:close]}"
      else
        display(annotations)
      end
    end

    private

    def scan(dir, annotations=[])
      Dir.glob("#{dir}/*") do |path|
        next if File.basename(path) =~ /(#{IGNORES.join('|')})$/

        if File.directory? path
          scan(path, annotations)
        else
          begin
            comment_closing_tags = %w(\*\/ -->)
            content = read_file(path, /(TODO|FIXME):?\s*(.*)/)
            Annotation.new(content) if content
          rescue
            nil
          end
        end
      end
    end

    def read_file(file, pattern)
      lineno = 0

      result = File.readlines(file).inject([]) do |list, line|
        lineno += 1
        next list unless line =~ pattern
        list << { :lineno => lineno, :tag => $1, :message => $2.gsub(/\s*(\*\/|-->)$/, '') }
      end

      result.empty? ? nil : { :file => file, :lines => result }
    end

    def open_file_at_line(file, line)
      command = file

      if ENV['EDITOR'] =~ /mate/
        command = "#{file} --line #{line}"
      elsif ENV['EDITOR'] =~ /vi|vim/
        command = "+#{line} #{file}"
      elsif ENV['EDITOR'] =~ /subl/
        command = "#{file}:#{line}"
      end

      Kernel.system("$EDITOR #{command}")
    end

    def display(annotations)
      id = 0

      annotations.each do |annotation|
        file = annotation[:file]
        lines = annotation[:lines]

        puts "\n#{file}"
        lines.each do |line|
          id += 1
          puts "##{id} [#{line[:tag]}] #{line[:message]}"
        end
      end
    end

  end
end
