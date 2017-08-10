require 'sham/config/assign'

describe Sham::Config::Assign do
  before(:all) do
    Object.send(:remove_const, :AssignTester) if defined?(AssignTester)
    class AssignTester; end
  end

  let(:id){ double }
  let(:options){ { :id => id } }
  let(:subject){ described_class.new(lambda{ options }) }
  let(:config){ subject.object(AssignTester) }
  let(:instance){ double.as_null_object }

  before{ AssignTester.stub(:new){ instance } }

  it 'sets default options' do
    instance.should_receive(:public_send).with('id=', id)
    config.options.sham
  end

  it 'prioritizes passed options' do
    instance.should_receive(:public_send).with('id=', 2)
    config.options(:id => 2).sham
  end

  it 'merges passed options' do
    instance.should_receive(:public_send).with('name=', 'A')
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

  it 'calls save if the instance responds to save' do
    instance.stub(:respond_to?).with(:save){ true }
    instance.should_receive(:save)
    config.options.sham
  end

  it 'does not call save on build' do
    instance.should_recieve(:save).never
    config.options.sham(true)
  end

  it 'does not call save if it does not respond to save' do
    instance.stub(:respond_to?).with(:save){ false }
    instance.should_receive(:save).never
    config.options.sham
  end
end
