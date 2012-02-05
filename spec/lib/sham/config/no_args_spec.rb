require 'sham/config/no_args'

describe Sham::Config::NoArgs do
  before(:all) do
    Object.send(:remove_const, :NoArgsTester) if defined?(NoArgsTester)
    class NoArgsTester
      attr_accessor :name

      def initialize(name = nil)
        self.name = name
      end
    end
  end

  let(:config){ subject.object(NoArgsTester) }

  it 'does not pass parameters by default' do
    NoArgsTester.should_receive(:new).with()
    config.options.sham
  end

  it 'allows passed parameters' do
    NoArgsTester.should_receive(:new).with(1)
    config.options(1).sham
  end
end
