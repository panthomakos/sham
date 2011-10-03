module Sham
  module Util
    def self.extract_options!(ary)
      ary.last.is_a?(::Hash) ? ary.pop : {}
    end

    def self.constantize(word)
      unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ word
        raise NameError, "#{word.inspect} is not a valid constant name!"
      end

      Object.module_eval("::#{$1}", __FILE__, __LINE__)
    end
  end
end
