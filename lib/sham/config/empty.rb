require 'sham/config/base'

module Sham
  class Config
    class Empty < Base
      def options(options = {})
        @options = options

        self
      end

      def args
        [@options]
      end
    end
  end
end
