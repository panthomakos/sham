require 'sham/config/base'
require 'sham/util'

module Sham
  class Config
    class NoArgs < Base
      def options(*args)
        @args = args

        self
      end

      def args
        @args
      end
    end
  end
end
