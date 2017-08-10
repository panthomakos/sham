require 'sham/config/parameters'

describe Sham::Config::Parameters do
  before(:all) do
    Object.send(:remove_const, :ParamTester) if defined?(ParamTester)
    class ParamTester
      attr_accessor :first, :last

      def initialize(first, last)
        self.first = first
        self.last = last
      end
    end
  end

  let(:first){ double }
  let(:last){ double }
  let(:params){ [first, last] }
  let(:subject){ described_class.new(lambda{ params }) }
  let(:config){ subject.object(ParamTester) }

  it 'passes default options' do
    ParamTester.should_receive(:new).with(*params)
    config.options.sham
  end

  it 'prioritizes passed options' do
    ParamTester.should_receive(:new).with('A', 'B')
    config.options('A', 'B').sham
  end

  it 'parses default options' do
    subject.should_receive(:parse!).with(first)
    subject.should_receive(:parse!).with(last)
    config.options.sham
  end

  it 'does not parse passed options' do
    subject.should_receive(:parse!).with(1).never
    subject.should_receive(:parse!).with(2).never
    config.options(1, 2).sham
  end
end
