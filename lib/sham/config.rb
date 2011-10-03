module Sham
  class << self
    def config klass, name = :default
      unless klass.include?(Sham::Shammable)
        klass.send(:include, Sham::Shammable)
      end
      yield(Sham::Config.new(klass, name))
    end
  end

  class Config
    def self.activate! root = nil
      root = Rails.root if root.nil? && defined?(Rails.root)
      Dir["#{root}/sham/**/*.rb"].each{ |f| load(f) }
    end

    attr_accessor :klass, :name

    def initialize klass, name
      self.klass = klass
      self.name = name
    end

    def attributes &config
      klass.add_sham_config(name, config)
    end

    def empty
      klass.add_sham_config(name, Proc.new{ Hash.new() })
    end
  end
end
