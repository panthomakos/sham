require 'spec_helper'

describe Sham do
  context '#string!' do
    it 'should be a string' do
      described_class.string!.should be_an_instance_of(String)
    end

    it 'should have a length of 10' do
      described_class.string!.length.should == 10
    end

    it 'should allow different lengths' do
      described_class.string!(10).length.should == 20
    end
  end

  context '#integer!' do
    it 'should be an integer' do
      described_class.integer!.should \
        be_an_instance_of(Fixnum)
    end

    it 'should be between 0 and 100' do
      10.times do
        described_class.integer!.should satisfy{ |x| x >= 0 && x < 100 }
      end
    end

    it 'should allow a differnet top' do
      10.times do
        described_class.integer!(10).should satisfy{ |x| x >= 0 && x < 10 }
      end
    end
  end
end
