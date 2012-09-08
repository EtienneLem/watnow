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
        next if File.basename(path) =~ /(#{Config.options['folder_ignore'].join('|')})$/

        if File.directory? path
          scan(path, annotations)
        else
          begin
            next if File.extname(path) =~ /(#{Config.options['file_extension_ignore'].join('|')})$/
            content = read_file(path, /(#{Config.options['patterns'].join('|')})/)
            Annotation.new(content) if content
          rescue
            nil
          end
        end
      end
    end

    def read_file(file, patterns)
      lineno = 0

      result = File.readlines(file).inject([]) do |list, line|
        lineno += 1
        next list unless line =~ patterns

        tag = line.slice!($1)

        priority = line.slice!(/\s(!+)\s?/)
        priority = $1 ? $1.length : 0

        mention = line.slice!(/\s@(\w+)\s*/)
        mention = $1

        message = line.slice!(/(\w.*)/)
        message = $1

        list << {
          :lineno => lineno,
          :tag => tag,
          :priority => priority,
          :mention => mention,
          :message => message.gsub(/\s*(\*\/|-->|%>)$/, '')
        }
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
      annotations.sort_by! { |a| [a.priority, -a.id] }
      annotations.each do |annotation|
        filename = annotation.file.gsub(/^\.\//, '')
        display_line "\n#{filename}", 'magenta'
        annotation.lines.each do |annotation_line|
          spaces_count = AnnotationLine.tag_length - annotation_line.tag.length
          spaces = Array.new(spaces_count + 1).join(' ')

          is_mentioned = (annotation_line.mention == Config.options['username'])
          display_text '[ ', 'green', is_mentioned
          display_text [annotation_line.id, *annotation_line.meta_data].join(' - '), 'cyan'
          display_text " ] #{' ' if annotation_line.id < 10}", 'green', is_mentioned
          display_text "#{annotation_line.tag}: #{spaces}#{annotation_line.message}", 'green', is_mentioned
          display_line ""
        end
      end
    end

    def display_line(msg, color=nil, color_condition=true)
      display_text "#{msg}\n", color, condition
    end

    def display_text(msg, color=nil, color_condition=true)
      output = color && condition && Config.options['color'] ? "#{msg}".send(color) : msg
      STDOUT.write "#{output}"
    end

  end
end
