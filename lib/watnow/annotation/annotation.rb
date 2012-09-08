module Watnow
  class Annotation

    @@id = 0
    @@instances = []

    attr_accessor :id, :file, :lines, :priority

    def self.all
      @@instances
    end

    def initialize(opts)
      super()
      @priority = 0
      @file = opts[:file]
      @lines = set_lines(opts[:lines])

      @id = @@id += 1
      @@instances << self
    end

    private

    def set_lines(lines)
      results = []

      lines.each do |line|
        results << AnnotationLine.new(line, self)
      end

      results
    end

  end
end
