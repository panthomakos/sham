require 'sham/shammable'
require 'sham/config/assign'
require 'sham/config/attributes'
require 'sham/config/parameters'
require 'sham/config/empty'
require 'sham/config/no_args'

module Sham
  class << self
    def config klass, name = :default
      unless (class << klass; self; end).include?(Sham::Shammable)
        klass.extend(Sham::Shammable)
      end
      yield(Sham::Config.new(klass, name)) if block_given?
    end
  end

  class Config
    def self.activate! root = nil
      root = Rails.root if root.nil? && defined?(Rails.root)
      root = File.join(root, 'sham', '**', '*.rb')
      Dir[root].each{ |f| load(f) }
    end

    def initialize klass, name
      @klass = klass
      @name = name
    end

    def assign(&config)
      @klass.add_sham_config(@name, Sham::Config::Assign.new(config))
    end

    def attributes(&config)
      @klass.add_sham_config(@name, Sham::Config::Attributes.new(config))
    end

    def parameters(&config)
      @klass.add_sham_config(@name, Sham::Config::Parameters.new(config))
    end

    def empty
      @klass.add_sham_config(@name, Sham::Config::Empty.new)
    end

    def no_args
      @klass.add_sham_config(@name, Sham::Config::NoArgs.new)
    end
  end
end
