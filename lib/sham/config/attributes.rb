require 'sham/config/base'

module Sham
  class Config
    class Attributes < Base
      def initialize(config)
        @config = config
      end

      def options(options = {})
        @options = options

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
