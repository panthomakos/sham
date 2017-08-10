require 'sham/nested'
require 'sham/lazy'

module Sham
  class Config
    class Base
      def object(klass)
        @klass = klass

        self
      end

      def sham(build = false)
        if build || !@klass.respond_to?(:create)
          @klass.new(*args)
        else
          @klass.create(*args)
        end
      end

      private

      def parse! value
        case value
        when Array then value.map{ |k| parse!(k) }
        when Hash then value.map{ |k,v| [k, parse!(v)] }.to_h
        when Sham::Nested then value.sham!
        when Sham::Lazy then value.sham!
        else value
        end
      end
    end
  end
end
