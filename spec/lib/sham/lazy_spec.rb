require 'sham/lazy'

describe Sham::Lazy do
  it 'makes a lazy sham' do
    expect(Sham::Lazy.new.is_a?(Sham::Lazy)).to be(true)
  end
end
