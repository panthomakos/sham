require 'sham/config/attributes'

describe Sham::Config::Attributes do
  before(:all) do
    Object.send(:remove_const, :AttributesTester) if defined?(AttributesTester)
    class AttributesTester
      attr_accessor :id

      def initialize(options)
        self.id = options[:id]
      end
    end
  end

  let(:id){ double }
  let(:options){ { :id => id } }
  let(:subject){ described_class.new(lambda{ options }) }
  let(:config){ subject.object(AttributesTester) }

  it 'passes default options' do
    AttributesTester.should_receive(:new).with(options)
    config.options.sham
  end

  it 'prioritizes passed options' do
    AttributesTester.should_receive(:new).with({ :id => 2 })
    config.options(:id => 2).sham
  end

  it 'merges passed options' do
    AttributesTester.should_receive(:new).with({ :id => id, :name => 'A' })
    config.options(:name => 'A').sham
  end

  it 'parses default options' do
    subject.should_receive(:parse!).with(id)
    config.options.sham
  end

  it 'does not parse passed options' do
    subject.should_receive(:parse!).with(2).never
    config.options(:id => 2).sham
  end
end
