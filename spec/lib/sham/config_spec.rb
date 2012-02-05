require 'spec_helper'

class Company < Object; end

describe Sham::Config do
  it 'activates shams in the root directory' do
    begin
      expect {
        described_class.activate!(SPEC_DIR)
      }.to change{ defined?(Employee) }.from(nil).to('constant')
    ensure
      Object.send(:remove_const, :Employee) rescue nil
    end
  end

  it 'extends the class with Sham::Shammable' do
    expect { Sham.config(Company){ |c| c.empty } } \
      .to change{ (class << Company; self; end).include?(Sham::Shammable) } \
      .from(false).to(true)
  end

  it 'only extends with Sham::Shammable once' do
    Company.should_receive(:extend).never

    Sham.config(Company, :alternate){ |c| c.empty }
  end

  it 'defines sham! on the class' do
    class BiggerCompany < Object; end

    expect {
      Sham.config(BiggerCompany){ |c| c.empty }
    }.to change{ BiggerCompany.respond_to?(:sham!) }.from(false).to(true)
  end

  it 'defines sham_alternate! on the class' do
    class BiggestCompany < Object; end

    expect {
      Sham.config(BiggestCompany){ |c| c.empty }
    }.to change{ BiggestCompany.respond_to?(:sham_alternate!) } \
      .from(false).to(true)
  end

  context 'shams' do
    it 'are individual to every class' do
      class A; def initialize(*args); end; end
      class B; def initialize(*args); end; end

      a = { :attribute => 'a' }
      b = { :attribute => 'b' }

      Sham.config(A){ |c| c.attributes{ a } }
      Sham.config(B){ |c| c.attributes{ b } }

      A.should_receive(:new).with(a)
      B.should_receive(:new).with(b)

      A.sham!
      B.sham!
    end

    it 'carries over to subclasses' do
      class SuperUser < User; end

      SuperUser.should respond_to(:sham!)
      SuperUser.sham![:identifier].should == User.sham![:identifier]
    end

    it 'allows subclasses to define their own shams' do
      class PowerUser < User; end

      Sham.config(PowerUser){ |c| c.empty }

      User.sham_config(:default) \
        .should_not == PowerUser.sham_config(:default)
    end

    it 'defaults to calling #new when #create is not present' do
      class SimpleUser
        def initialize(options = {}); end
      end

      Sham.config(SimpleUser){ |c| c.empty }

      SimpleUser.should_receive(:new).once

      SimpleUser.sham!
    end

    it 'allows shams to be built instead of created' do
      User.should_receive(:create).never

      User.sham!(:build)
    end

    it 'creates shams by default' do
      User.should_receive(:create).once

      User.sham!
    end

    it 'allows alternate shams to be built' do
      User.should_receive(:create).never

      User.sham!(:build, :super)
    end

    it 'allows alternate shams to be created' do
      User.should_receive(:create).once

      User.sham!(:super)
    end

    it 'shams alternatives with alternative options' do
      User.sham!(:super)[:identifier] \
        .should_not == User.sham![:identifier]
    end

    it 'performs nested shams' do
      Profile.should_receive(:sham!).once

      User.sham!(:with_profile)
    end

    it 'allows nested shams to be overwritten' do
      profile = Profile.new

      User.sham!(:with_profile, :profile => profile)[:profile] \
        .should == profile

      User.sham!(:with_profile)[:profile] \
        .should_not == profile
    end
  end
end
