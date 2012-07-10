require 'sham/util'

module Sham
  class Config
    module HashOptions
      def options(*args)
        @options = ::Sham::Util.extract_options!(args)

        @config.call.each do |key, value|
          @options[key] = parse!(value) unless @options.has_key?(key)
        end

        self
      end
    end
  end
end
