require 'sham/nested'

describe Sham::Nested do
  it 'is a sham base' do
    Sham::Nested.new(stub).is_a?(Sham::Base).should be_true
  end

  it 'makes a sham base a sham nested' do
    Sham::Base.new(stub).is_a?(Sham::Nested).should be_true
  end
end
