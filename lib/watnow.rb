require 'watnow/version'
require 'watnow/config'
require 'watnow/option_parser'
require 'watnow/annotation/annotation'
require 'watnow/annotation/annotation_line'
require 'colored'

module Watnow
  class Extractor

    def initialize
      options = OptParser.parse(ARGV)
      config = Config.init

      scan(options[:directory])

      if options[:open]
        id = Integer(options[:open])
        annotation_line = AnnotationLine.find(id)
        open_file_at_line(annotation_line.annotation.file, annotation_line.lineno)
      elsif options[:remove]
        id = Integer(options[:remove])
        annotation_line = AnnotationLine.find(id)
        remove_line_of_file(annotation_line.annotation.file, annotation_line.lineno)
      else
        display(Annotation.all)
      end
    end

    private

    def scan(dir, annotations=[])
      Dir.glob("#{dir}/*") do |path|
        next if File.basename(path) =~ /(#{Config.options['ignores'].join('|')})$/

        if File.directory? path
          scan(path, annotations)
        else
          begin
            content = read_file(path, /(#{Config.options['patterns'].join('|')}):?\s*(.*)/)
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
        list << { :lineno => lineno, :tag => $1, :message => $2.gsub(/\s*(\*\/|-->|%>)$/, '') }
      end

      result.empty? ? nil : { :file => file, :lines => result }
    end

    def open_file_at_line(filename, line)
      command = filename

      if ENV['EDITOR'] =~ /mate/
        command = "#{filename} --line #{line}"
      elsif ENV['EDITOR'] =~ /vi|vim/
        command = "+#{line} #{filename}"
      elsif ENV['EDITOR'] =~ /subl/
        command = "#{filename}:#{line}"
      end

      Kernel.system("$EDITOR #{command}")
    end

    def remove_line_of_file(filename, line)
      file = File.readlines(filename)
      file.delete_at(line - 1)
      File.open(filename, 'w+') {|f| f.write file.join() }
    end

    def display(annotations)
      id = 0

      annotations.each do |annotation|
        filename = annotation.file.gsub(/^\.\//, '')
        display_line "\n#{filename}", 'magenta'
        annotation.lines.each do |annotation_line|
          id += 1
          display_text "[ "
          display_text "#{annotation_line.id}", 'cyan'
          display_text " ] #{' ' if id < 10}"
          display_line "#{annotation_line.tag}: #{annotation_line.message}"
        end
      end
    end

    def display_line(msg, color=nil)
      display_text "#{msg}\n", color
    end

    def display_text(msg, color=nil)
      output = color && Config.options['color'] ? "#{msg}".send(color) : msg
      STDOUT.write "#{output}"
    end

  end
end
