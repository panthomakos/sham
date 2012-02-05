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
      else
        superclass.sham_config(name)
      end
    end

    def sham!(*args)
      options = Sham::Util.extract_options!(args)
      type = (args[0] == :build ? args[1] : args[0]) || :default
      build = args[0] == :build || args[1] == :build

      sham_config(type).object(self).options(options).sham(build)
    end

    alias :sham_alternate! :sham!
  end
end
