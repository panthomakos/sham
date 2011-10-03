module Sham
  class << self
    def parse! value
      if value.is_a?(Array)
        value.map{ |k| parse!(k) }
      elsif value.is_a?(Hash)
        Hash.new value.map{ |k,v| [k, parse!(v)] }
      elsif value.is_a?(Sham::Base)
        value.sham!
      else
        value
      end
    end

    def add_options! klass, options = {}, attributes
      attributes.call.each do |key, value|
        options[key] = parse!(value) unless options.has_key?(key)
      end
    end
  end

  module Shammable
    def self.included(klass)
      klass.extend(ClassMethods)

      (class << klass; self; end).instance_eval do
        attr_accessor :sham_configs

        define_method(:add_sham_config) do |name, config|
          self.sham_configs ||= {}
          self.sham_configs[name] = config
        end

        define_method(:sham_config) do |name|
          if sham_configs && sham_configs.has_key?(name)
            sham_configs[name]
          else
            superclass.sham_config(name)
          end
        end
      end
    end

    module ClassMethods
      def sham! *args
        options = Sham::Util.extract_options!(args)
        type = (args[0] == :build ? args[1] : args[0]) || :default
        build = args[0] == :build || args[1] == :build

        ::Sham.add_options!(name, options, sham_config(type))
        klass = Sham::Util.constantize(options.delete(:type) || self.name)
        if build || !klass.respond_to?(:create)
          klass.new(options)
        else
          klass.create(options)
        end
      end

      alias :sham_alternate! :sham!
    end
  end
end