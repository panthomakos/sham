module Sham
  class Base
    attr_accessor :klass, :options

    def initialize klass, options = {}
      @klass = klass
      @options = options
    end

    def sham!
      @klass.sham! @options
    end
  end

  class Config
    def self.activate!
      Dir["#{Rails.root}/sham/**/*.rb"].each do |f|
        load f
      end
    end

    attr_accessor :klass, :name

    def initialize klass, name
      self.klass = klass
      self.name = name
    end

    def attributes &attributes
      klass.add_sham_attributes(name, attributes)
    end

    def empty
      klass.add_sham_attributes(name, Proc.new{ Hash.new() })
    end
  end

  def self.config klass, name = :default
    unless klass.include?(Sham::Shammable)
      klass.send(:include, Sham::Shammable)
    end
    yield(Sham::Config.new(klass, name))
  end

  def self.string!
    ActiveSupport::SecureRandom.hex(5)
  end

  def self.parse! value
    if value.is_a?(Array)
      value.map{ |k| parse! k }
    elsif value.is_a?(Hash)
      Hash.new value.map{ |k,v| [k, parse!(v)] }
    elsif value.is_a?(Sham::Base)
      value.sham!
    else
      value
    end
  end

  def self.add_options! klass, options = {}, attributes
    attributes.call.each do |key, value|
      options[key] = self.parse!(value) unless options.has_key?(key)
    end
  end

  module Shammable
    def self.included(klass)
      klass.extend(ClassMethods)

      klass.class_eval <<-EVAL
        def self.add_sham_attributes name, attributes
          @@sham_attributes ||= {}
          @@sham_attributes[name] = attributes
        end

        def self.sham_attributes
          @@sham_attributes
        end
      EVAL
    end

    module ClassMethods
      def sham! *args
        options = (args.extract_options! || {})
        type = (args[0] == :build ? args[1] : args[0]) || :default
        build = args[0] == :build || args[1] == :build

        ::Sham.add_options! self.name, options, sham_attributes[type]
        klass = (options.delete(:type) || self.name).constantize
        if build
          klass.new(options)
        else
          klass.create(options)
        end
      end

      def sham_alternate! type, *args
        sham!(type, *args)
      end
    end
  end
end
