require 'sham/config/base'
require 'sham/util'

module Sham
  class Config
    class Empty < Base
      def options(*args)
        @options = ::Sham::Util.extract_options!(args)

        self
      end

      def args
        [@options]
      end
    end
  end
end
