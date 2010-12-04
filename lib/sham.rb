module Sham
  class Core
    def self.options
      {}
    end
  end
    
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
      Dir["#{RAILS_ROOT}/sham/*_sham.rb"].each{ |f| require f }
    
      Sham.constants.each do |klass|
        matcher = klass.match(/(.*)Sham/)
        matcher[1].constantize.send(:include, Sham::Methods) unless matcher.blank?
      end
    end
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

  def self.add_options! klass, options = {}, options_string = "options"
    eval("Sham::#{klass}Sham.#{options_string}").each do |key, value|
      options[key] = Sham.parse!(value) unless options.has_key?(key)
    end
  end

  module Methods
    def self.included klass
      klass.class_eval do
        def self.sham! *args
          options = (args.extract_options! || {})
          Sham.add_options! self.name, options
          klass = (options.delete(:type) || self.name).constantize
          return klass.create(options) unless args[0] == :build
          return klass.new(options)
        end

        def self.sham_alternate! type, *args
          options = (args.extract_options! || {})
          Sham.add_options! self.name, options, "#{type}_options"
          klass = (options.delete(:type) || self.name).constantize
          return klass.create(options) unless args[0] == :build
          return klass.new(options)
        end
      end
    end
  end
end