require 'watnow/version'
require 'watnow/config'
require 'watnow/option_parser'
require 'watnow/annotation/annotation'
require 'watnow/annotation/annotation_line'
require 'colored'

module Watnow
  class Extractor
    include Watnow::Config

    def initialize
      # Parse options and scan given directory
      options = OptParser.parse(ARGV)
      scan(options[:directory])

      # If open command is parsed (`watnow open 13`)
      if options[:open]
        id = Integer(options[:open])
        annotation_line = AnnotationLine.find(id)
        open_file_at_line(annotation_line.annotation.file, annotation_line.lineno)

      # If remove command is parsed (`watnow remove 13`)
      elsif options[:remove]
        id = Integer(options[:remove])
        annotation_line = AnnotationLine.find(id)
        remove_line_of_file(annotation_line.annotation.file, annotation_line.lineno)

      # No specific command parsed. Output the annotations list
      else
        output(Annotation.all)
      end
    end

    private

    # Recursively scan given directory
    # Ignore folders and files from Config
    # Create a new Annotation when data si found
    def scan(dir, annotations=[])
      Dir.glob("#{dir}/*") do |path|
        next if File.basename(path) =~ /(#{Config.folder_ignore.join('|')})$/

        if File.directory? path
          scan(path, annotations)
        else
          begin
            next if File.extname(path) =~ /(#{Config.file_extension_ignore.join('|')})$/
            content = read_file(path, /(#{Config.patterns.join('|')})/i)
            Annotation.new(content) if content
          rescue
            nil
          end
        end
      end
    end

    # Read a file line by line and look for given patterns
    def read_file(file, patterns)
      lineno = 0

      result = File.readlines(file).inject([]) do |list, line|
        lineno += 1
        next list unless line =~ patterns

        # Pattern is found, save the tag
        tag = line.slice!($1)

        # Look for priority
        # Exclamation mark (!) preceded by a whitespace
        priority = line.slice!(/\s(!+)\s?/)
        priority = $1 ? $1.length : 0

        # Look for mention
        # Any word character preceded by @
        mention = line.slice!(/\s@(\w+)\s*/)
        mention = $1

        # We assume the message starts with any word character
        message = line.slice!(/(\w.*)/)
        message = $1

        # Push data into result
        # Remove closing comment characters that we didn’t extract from regexs
        list << {
          :lineno => lineno,
          :tag => tag,
          :priority => priority,
          :mention => mention,
          :message => message.gsub(/\s*(\*\/|-->|%>)$/, '')
        }
      end

      # Returns content that is sent to Annotation
      result.empty? ? nil : { :file => file, :lines => result }
    end

    # Open a file with the user’s $EDITOR
    # Automatically focus the annotation line number
    # Supported editors are TextMate, Vim & Sublime Text
    def open_file_at_line(filename, line)
      command = filename
      editor = ENV['EDITOR']

      if ENV['EDITOR'] =~ /mate/
        command = "#{filename} --line #{line}"
        # Remove TextMate -w (wait) option
        editor =~ /(-\w*(w))/
        editor = editor.gsub($1, $1.gsub($2, ''))
      elsif ENV['EDITOR'] =~ /vi|vim/
        command = "+#{line} #{filename}"
      elsif ENV['EDITOR'] =~ /subl/
        command = "#{filename}:#{line}"
      end

      Kernel.system("#{editor} #{command}")
    end

    # Remove line from given file
    def remove_line_of_file(filename, line)
      file = File.readlines(filename)
      file.delete_at(line - 1)
      File.open(filename, 'w+') {|f| f.write file.join() }
    end

    def output(annotations)
      # Sort annotations (file) by priority then by id
      annotations.sort_by! { |a| [a.priority, -a.id] }

      annotations.each do |annotation|
        # Remove './' prefix in filenames
        filename = annotation.file.gsub(/^\.\//, '')

        # Display the filename
        display_line "\n#{filename}", 'magenta'

        # Sort annotation lines by priority DESC
        # Higher priority is lower in the list
        annotation.lines.sort! { |a,b| a.priority <=> b.priority }
        annotation.lines.each do |annotation_line|
          # Make sure all tags use the same (white)space
          tag_spaces_count = AnnotationLine.tag_length - annotation_line.tag.length
          tag_spaces = Array.new(tag_spaces_count + 1).join(' ')

          # Boolean. True if current user is being mentioned in the annotation line
          is_mentioned = !Config.username.empty? && (annotation_line.mention.downcase == Config.username.downcase)

          # The actual outputting
          display_text '[ ', 'green', is_mentioned
          display_text annotation_line.id, 'cyan'
          display_text " ] #{' ' if annotation_line.id < 10}", 'green', is_mentioned
          display_text "#{annotation_line.tag}: #{tag_spaces}#{annotation_line.message}", 'green', is_mentioned
          if annotation_line.meta_data.size > 0
            display_text ' [ ', 'green', is_mentioned
            display_text annotation_line.meta_data.join(' - '), 'cyan'
            display_text ' ]', 'green', is_mentioned
          end
          display_line ""
        end
      end
    end

    # display_text followed by a newline
    def display_line(msg, color=nil, color_condition=true)
      display_text "#{msg}\n", color, color_condition
    end

    # Output helper. Print text in color if color_condition is truthy
    def display_text(msg, color=nil, color_condition=true)
      output = color && color_condition && Config.color ? "#{msg}".send(color) : msg
      STDOUT.write "#{output}"
    end

  end
end
