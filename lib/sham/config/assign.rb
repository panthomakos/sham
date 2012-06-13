require 'sham/config/base'
require 'sham/util'

module Sham
  class Config
    class Assign < Base
      def initialize(config)
        @config = config
      end

      def sham(build = false)
        object = super(true)

        @options.each do |key, value|
          object.public_send("#{key}=", value)
        end

        if !build && object.respond_to?(:save)
          object.save
        end

        object
      end

      def options(*args)
        @options = ::Sham::Util.extract_options!(args)

        @config.call.each do |key, value|
          @options[key] = parse!(value) unless @options.has_key?(key)
        end

        self
      end

      def args
        []
      end
    end
  end
end
