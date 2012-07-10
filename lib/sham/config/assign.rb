require 'sham/config/base'
require 'sham/config/hash_options'

module Sham
  class Config
    class Assign < Base
      include HashOptions

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

      def args
        []
      end
    end
  end
end
