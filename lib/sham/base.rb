module Sham
  class Base
    attr_accessor :klass, :options

    def initialize klass, options = {}
      @klass = klass
      @options = options
    end

    def sham!
      @klass.sham!(@options)
    end
  end
end
