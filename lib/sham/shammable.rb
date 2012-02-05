require 'sham/util'

module Sham
  module Shammable
    def add_sham_config(name, config)
      @sham_configs ||= {}
      @sham_configs[name] = config
    end

    def sham_config(name)
      if @sham_configs && @sham_configs.has_key?(name)
        @sham_configs[name]
      elsif superclass.respond_to?(:sham_config)
        superclass.sham_config(name)
      end
    end

    def sham!(*args)
      build = extract_build!(args)
      type = extract_type!(args) || :default
      build ||= extract_build!(args)

      sham_config(type).object(self).options(*args).sham(build == :build)
    end

    alias :sham_alternate! :sham!

    private

    def extract_build!(args)
      args.shift if args.first == :build
    end

    def extract_type!(args)
      args.shift if sham_config(args.first)
    end
  end
end
