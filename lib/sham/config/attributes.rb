require 'sham/config/base'
require 'sham/util'

module Sham
  class Config
    class Attributes < Base
      def initialize(config)
        @config = config
      end

      def options(*args)
        @options = ::Sham::Util.extract_options!(args)

        @config.call.each do |key, value|
          @options[key] = parse!(value) unless @options.has_key?(key)
        end

        self
      end

      def args
        [@options]
      end
    end
  end
end
