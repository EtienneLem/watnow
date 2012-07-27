module Watnow
  class Annotation

    @@instances = []

    attr_accessor :file, :lines

    def self.all
      @@instances
    end

    def initialize(opts)
      super()
      @file = opts[:file]
      @lines = set_lines(opts[:lines])

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
