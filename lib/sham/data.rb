require 'securerandom'

module Sham
  class << self
    def string! len = 5
      ::SecureRandom.hex(len)
    end

    def integer! top = 100
      ::SecureRandom.random_number(top)
    end
  end
end
