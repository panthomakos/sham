module Sham
  class Lazy
    def initialize(&block)
      @block = block
    end

    def sham!
      @block.call
    end
  end
end
