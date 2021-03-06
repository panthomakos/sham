require 'sham/base'

describe Sham::Base do
  let(:klass){ double }

  it 'should call sham! on the class' do
    klass.should_receive(:sham!)
    described_class.new(klass).sham!
  end

  it 'should pass sham options' do
    options = double
    klass.should_receive(:sham!).with(options)
    described_class.new(klass, options).sham!
  end
end
