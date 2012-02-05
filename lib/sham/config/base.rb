require 'sham/base'

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
        if value.is_a?(Array)
          value.map{ |k| parse!(k) }
        elsif value.is_a?(Hash)
          Hash.new value.map{ |k,v| [k, parse!(v)] }
        elsif value.is_a?(Sham::Base)
          value.sham!
        else
          value
        end
      end
    end
  end
end
