require 'spec_helper'

describe Sham::Util do
  context '#extract_options!' do
    let(:ary){ [1, 2, 3, 4, {:opt => 'arg', :opt2 => 'arg'}] }

    it 'should alter the original array' do
      expect {
        described_class.extract_options!(ary)
      }.to change{ ary.count }.from(5).to(4)
    end

    it 'should return the hash' do
      described_class.extract_options!(ary).keys.should include(:opt, :opt2)
    end

    it 'should succeed when there are no options to extract' do
      described_class.extract_options!([1,2,3]).should == {}
    end

    it 'should succeed when the array is empty' do
      described_class.extract_options!([]).should == {}
    end

    it 'should fail if the argument is not an array' do
      expect {
        described_class.extract_options!(10)
      }.to raise_error(NoMethodError)
    end
  end

  context '#constantize' do
    it 'should raise a NameError when the constant is not valid' do
      expect {
        described_class.constantize('user')
      }.to raise_error(NameError)
    end

    it 'should raise a NameError when the constant is undefined' do
      expect {
        described_class.constantize("U#{Sham.string!}")
      }.to raise_error(NameError)
    end

    it 'should return the constant' do
      described_class.constantize('User').should == User
    end
  end
end
