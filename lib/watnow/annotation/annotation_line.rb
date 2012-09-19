module Watnow
  class AnnotationLine

    @@id = 0
    @@instances = []
    @@tag_length = 0

    attr_accessor :id, :lineno, :tag, :priority, :mention, :message, :annotation

    def self.find(id)
      @@instances.each do |instance|
        return instance if instance.id == id
      end

      nil
    end

    def self.tag_length
      @@tag_length
    end

    def initialize(opts, annotation)
      super()
      @lineno = opts[:lineno]
      @tag = opts[:tag]
      @priority = opts[:priority] || 0
      @mention = opts[:mention] || ''
      @message = opts[:message]
      @annotation = annotation

      @annotation.priority = @priority if @priority > @annotation.priority

      @id = @@id += 1
      @@instances << self

      @@tag_length = @tag.length if @tag.length > @@tag_length
    end

    def meta_data
      data = []
      data << "@#{@mention}" unless @mention.empty?
      data << Array.new(@priority + 1).join('!') if @priority > 0
      data
    end

  end
end
