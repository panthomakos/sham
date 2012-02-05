require 'sham/config/base'

module Sham
  class Config
    class Parameters < Base
      def initialize(config)
        @config = config
      end

      def options(*args)
        @args = args

        if @args.empty?
          @config.call.each do |arg|
            @args << parse!(arg)
          end
        end

        self
      end

      def args
        @args
      end
    end
  end
end
