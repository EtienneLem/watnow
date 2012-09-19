module Watnow
  class AnnotationLine

    @@id = 0
    @@instances = []
    @@tag_length = 0

    attr_accessor :id, :lineno, :tag, :priority, :mention, :message, :annotation

    # An ORM-like find method that returns an AnnotationLine instance
    def self.find(id)
      @@instances.each do |instance|
        return instance if instance.id == id
      end

      nil
    end

    # Returns longest tag length
    # Used to format output
    def self.tag_length
      @@tag_length
    end

    def initialize(opts, annotation)
      @lineno = opts[:lineno]
      @tag = opts[:tag]
      @priority = opts[:priority] || 0
      @mention = opts[:mention] || ''
      @message = opts[:message]
      @annotation = annotation

      @annotation.priority = @priority if @priority > @annotation.priority

      # Auto increment instances id
      # Push instance into a class array
      @id = @@id += 1
      @@instances << self

      # Update class’ tag_length to the longest tag
      @@tag_length = @tag.length if @tag.length > @@tag_length
    end

    # Returns an array of "meta data"
    # Namely: The AnnotationLine mention and priority
    def meta_data
      data = []
      data << "@#{@mention}" unless @mention.empty?
      data << Array.new(@priority + 1).join('!') if @priority > 0
      data
    end

  end
end
