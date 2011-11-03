require 'spec_helper'

class Company < Object; end

describe Sham::Config do
  it 'should activate shams in the root directory' do
    begin
      expect {
        described_class.activate!(SPEC_DIR)
      }.to change{ defined?(Employee) }.from(nil).to('constant')
    ensure
      Object.send(:remove_const, :Employee) rescue nil
    end
  end

  it 'should include Sham::Shammable when configured' do
    expect {
      Sham.config(Company){ |c| c.empty }
    }.to change{ Company.include?(Sham::Shammable) }.from(false).to(true)
  end

  it 'should only include Sham::Shammable once when configured' do
    Company.should_receive(:include).never

    Sham.config(Company, :alternate){ |c| c.empty }
  end

  it 'should define sham! on the class' do
    class BiggerCompany < Object; end

    expect {
      Sham.config(BiggerCompany){ |c| c.empty }
    }.to change{ BiggerCompany.respond_to?(:sham!) }.from(false).to(true)
  end

  it 'should define sham_alternate! on the class' do
    class BiggestCompany < Object; end

    expect {
      Sham.config(BiggestCompany){ |c| c.empty }
    }.to change{ BiggestCompany.respond_to?(:sham_alternate!) } \
      .from(false).to(true)
  end

  context 'shams' do
    it 'should carry shams over to subclasses' do
      class SuperUser < User; end

      SuperUser.should respond_to(:sham!)
      SuperUser.sham![:identifier].should == User.sham![:identifier]
    end

    it 'should allow subclasses to define their own shams' do
      class PowerUser < User; end

      Sham.config(PowerUser){ |c| c.empty }

      User.sham_config(:default) \
        .should_not == PowerUser.sham_config(:default)
    end

    it 'should default to calling #new when #create is not present' do
      class SimpleUser
        def initialize(options = {}); end
      end

      Sham.config(SimpleUser){ |c| c.empty }

      SimpleUser.should_receive(:new).once

      SimpleUser.sham!
    end

    it 'should allow shams to be built instead of created' do
      User.should_receive(:create).never

      User.sham!(:build)
    end

    it 'should create shams by default' do
      User.should_receive(:create).once

      User.sham!
    end

    it 'should allow alternate shams to be built' do
      User.should_receive(:create).never

      User.sham!(:build, :super)
    end

    it 'should allow alternate shams to be created' do
      User.should_receive(:create).once

      User.sham!(:super)
    end

    it 'should sham alternatives with alternative options' do
      User.sham!(:super)[:identifier] \
        .should_not == User.sham![:identifier]
    end

    it 'should perform nested shams' do
      Profile.should_receive(:sham!).once

      User.sham!(:with_profile)
    end

    it 'should allow nested shams to be overwritten' do
      profile = Profile.new

      User.sham!(:with_profile, :profile => profile)[:profile] \
        .should == profile

      User.sham!(:with_profile)[:profile] \
        .should_not == profile
    end
  end
end
