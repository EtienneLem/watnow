module Watnow
  class AnnotationLine

    @@id = 0
    @@instances = []

    attr_accessor :id, :lineno, :tag, :message, :annotation

    def self.find(id)
      @@instances.each do |instance|
        return instance if instance.id == id
      end

      nil
    end

    def initialize(opts, annotation)
      super()
      @lineno = opts[:lineno]
      @tag = opts[:tag]
      @message = opts[:message]
      @annotation = annotation

      @id = @@id += 1
      @@instances << self
    end

  end
end
