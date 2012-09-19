module Watnow
  # An Annotation is basically a group of AnnotationLine
  class Annotation

    @@id = 0
    @@instances = []

    attr_accessor :id, :file, :lines, :priority

    # An ORM-like method that returns all Annotation instances
    def self.all
      @@instances
    end

    def initialize(opts)
      @priority = 0
      @file = opts[:file]
      @lines = set_lines(opts[:lines])

      # Auto increment instances id
      # Push instance into a class array
      @id = @@id += 1
      @@instances << self
    end

    private

    # Loop through lines data and create AnnotationLine instance
    # Send self so that an AnnotationLine knows its Annotation and vice versa
    def set_lines(lines)
      results = []

      lines.each do |line|
        results << AnnotationLine.new(line, self)
      end

      results
    end

  end
end
