require 'spec_helper'

describe Sham::Base do
  let(:base){ Sham::Base.new(User, name: Sham.string!) }

  it 'should call sham! on the klass' do
    User.should_receive(:sham!)
    base.sham!
  end

  it 'should properly set the attributes' do
    user = base.sham!
    user[:name].should == base.options[:name]
  end
end
