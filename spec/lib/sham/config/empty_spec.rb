require 'sham/config/empty'

describe Sham::Config::Empty do
  before(:all) do
    Object.send(:remove_const, :EmptyTester) if defined?(EmptyTester)
    class EmptyTester
      attr_accessor :id

      def initialize(options)
        self.id = options[:id]
      end
    end
  end

  let(:config){ subject.object(EmptyTester) }

  it 'passes an empty hash by default' do
    EmptyTester.should_receive(:new).with({})
    config.options.sham
  end

  it 'allows passed options' do
    EmptyTester.should_receive(:new).with(:id => 1)
    config.options(:id => 1).sham
  end
end
