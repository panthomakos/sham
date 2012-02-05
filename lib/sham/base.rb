module Sham
  class Base
    def initialize klass, *args
      @klass = klass
      @args = args
    end

    def sham!
      @klass.sham!(*@args)
    end
  end
end
