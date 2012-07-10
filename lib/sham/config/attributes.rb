require 'sham/config/base'
require 'sham/config/hash_options'

module Sham
  class Config
    class Attributes < Base
      include HashOptions

      def initialize(config)
        @config = config
      end

      def args
        [@options]
      end
    end
  end
end
