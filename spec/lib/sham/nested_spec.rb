require 'sham/nested'

describe Sham::Nested do
  it 'is a sham base' do
    expect(Sham::Nested.new(double).is_a?(Sham::Base)).to be(true)
  end

  it 'makes a sham base a sham nested' do
    expect(Sham::Base.new(double).is_a?(Sham::Nested)).to be(true)
  end
end
