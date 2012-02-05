module Sham
  class << self
    def config klass, name = :default
      unless (class << klass; self; end).include?(Sham::Shammable)
        klass.extend(Sham::Shammable)
      end
      yield(Sham::Config.new(klass, name))
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

    def attributes &config
      @klass.add_sham_config(@name, config)
    end

    def empty
      @klass.add_sham_config(@name, Proc.new{ Hash.new() })
    end
  end
end
