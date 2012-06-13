require 'sham/config'

describe Sham::Config do
  let(:parent) do
    Object.send(:remove_const, :Parent) if defined?(Parent)
    class Parent; end
    Parent
  end
  let(:child) do
    Object.send(:remove_const, :Child) if defined?(Child)
    class Child < parent; end
    Child
  end

  context '#activate!' do
    it 'activates shams in the root directory' do
      begin
        expect {
          described_class.activate!('spec/root')
        }.to change{ defined?(Employee) }.from(nil).to('constant')
      ensure
        Object.send(:remove_const, :Employee) rescue nil
      end
    end
  end

  context '#config' do
    it 'extends the class with Sham::Shammable' do
      expect { Sham.config(parent) } \
        .to change{ (class << parent; self; end).include?(Sham::Shammable) } \
        .from(false).to(true)
    end

    it 'only extends with Sham::Shammable once' do
      Sham.config(parent)
      parent.should_receive(:extend).never

      Sham.config(parent, :alternate)
    end

    it 'defines sham! on the class' do
      expect { Sham.config(parent) } \
        .to change{ parent.respond_to?(:sham!) }.from(false).to(true)
    end

    it 'defines sham_alternate! on the class' do
      expect { Sham.config(parent) } \
        .to change{ parent.respond_to?(:sham_alternate!) } \
        .from(false).to(true)
    end
  end

  context 'configured sham' do
    it 'should be individual to every class' do
      class A; end
      class B; end

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
      Sham.config(parent)
      child.should respond_to(:sham!)
    end

    it 'allows subclasses to define their own' do
      Sham.config(parent){ |c| c.empty }
      Sham.config(child){ |c| c.empty }

      parent.sham_config(:default) \
        .should_not == child.sham_config(:default)
    end

    it 'defaults to calling #new when #create is not present' do
      Sham.config(parent){ |c| c.empty }

      parent.should_receive(:new).once

      parent.sham!
    end

    it 'allows shams to be built instead of created' do
      Sham.config(parent){ |c| c.empty }
      parent.should_receive(:create).never
      parent.should_receive(:new).once

      parent.sham!(:build)
    end

    it 'creates shams by default' do
      Sham.config(parent){ |c| c.empty }
      parent.stub(:create)
      parent.should_receive(:create).once

      parent.sham!
    end

    context 'alternative shams' do
      let(:other){ { :id => 1 } }

      before do
        Sham.config(parent){ |c| c.empty }
        Sham.config(parent, :other){ |c| c.attributes{ other } }
      end

      it 'builds them' do
        parent.should_receive(:new).with(other)

        parent.sham!(:build, :other)
      end

      it 'creates them' do
        parent.should_receive(:create).with(other)

        parent.sham!(:other)
      end
    end

    context 'nested shams' do
      before do
        parent.stub(:create)

        Sham.config(parent) do |c|
          c.attributes do
            { :child => Sham::Nested.new(child) }
          end
        end
      end

      it 'calls them' do
        child.should_receive(:sham!)

        parent.sham!
      end

      it 'prefers passed options' do
        other_child = stub
        parent.should_receive(:create).with({ :child => other_child })
        parent.sham!(:child => other_child)
      end
    end
  end

  it 'configures assign shams' do
    Sham.config(parent) do |c|
      c.assign{ { :first => 'first' } }
    end

    instance = stub
    parent.stub(:new){ instance }
    instance.should_receive(:first=).with('first')
    parent.sham!.should == instance
  end

  it 'configures attribute shams' do
    attributes = { :first => 'first', :last => 'last' }
    Sham.config(parent) do |c|
      c.attributes{ attributes }
    end

    parent.should_receive(:new).with(attributes)
    parent.sham!
  end

  it 'configures empty shams' do
    Sham.config(parent){ |c| c.empty }
    parent.should_receive(:new).with({})
    parent.sham!
  end

  it 'configures no arg shams' do
    Sham.config(parent){ |c| c.no_args }
    parent.should_receive(:new).with()
    parent.sham!
  end

  it 'configures parameter shams' do
    parameters = [:first, :second]
    Sham.config(parent) do |c|
      c.parameters{ parameters }
    end

    parent.should_receive(:new).with(*parameters)
    parent.sham!
  end
end
