# Sham

Lightweight flexible factories for Ruby and Rails testing.

## Installation

    gem install sham

## Getting Started

Create a configuration file for any of your models or classes.

    # sham/user.rb
    Sham.config(User) do |c|
      c.attributes do
        { :name => "Sample User" }
      end
    end

To load your shams you can either include a configuration file directly, or
define your shams inline in your test file. Sham provides a helper function to
load all files under the sham directory. To load all your shams in a Rails
project you could add the following to your `test.rb` file.

    config.after_initialize do
      Sham::Config.activate!
    end

If you aren't using Rails you can activate all of your shams by specifying a
configuration path. This command will load all Ruby files under the
`/my/project/path/sham` directory.

    Sham::Config.activate!('/my/project/path')

To load all your shams in cucumber, modify your `features/support/env.rb` file.

    require 'sham'
    Sham::Config.activate!

You can now "sham" your models with their default options, or pass additional
attributes you would like to overwrite or add during creation.

    User.sham!
    User.sham!(:name => "New Name")
    User.sham!(:age => 23)

Sham can also create objects without automatically saving using the `:build`
option.

    user = User.sham!(:build, :name => "I have not been saved")
    user.save

## RSpec Example

Here is an example of testing validations on an `ActiveRecord::Base` class using
Sham and RSpec:

    # in app/models/item.rb
    class Item < ActiveRecord::Base
      validates_numericality_of :quantity, :greater_than => 0
    end

    # in sham/item.rb
    Sham.config(Item) do |c|
      c.attributes do
        { :quantity => 1 }
      end
    end

    # in spec/models/item_spec.rb
    require 'spec_helper'
    require './sham/item'

    describe Item do
      it "should not allow items with a negative price" do
        item = Item.sham!(:build, :quantity => -1)
        item.valid?.should be_false
      end

      it "should allow items with a positive quantity" do
        item = Item.sham!(:build, :quantity => 10)
        item.valid?.should be_true
      end
    end

## Parameter Shams

You can also define shams for initializers that take parameters instead of
attribute hashes. For example, if you had a `User` class:

    # in lib/user.rb
    class User
      attr_accessor :first, :last

      def initialize(first, last)
        self.first = first
        self.last = last
      end
    end

You could create a parameter sham like this:

    # in sham/user.rb
    Sham.config(User) do |c|
      c.parameters do
        ['John', 'Doe']
      end
    end

And invoke it like this:

    User.sham!
    User.sham!('Jane', 'Doe')

Unlike attribute shams, if arguments are passed to a parameter sham, those
arguments are the only ones passed to the constructor and the parameters are
not merged with the default ones.

## Alternative Shams

Sometimes you want to be able to configure more than one factory. Sham allows
you to easily define alternative sham configurations like this:

    # in sham/item.rb
    Sham.config(Item, :small) do |c|
      c.attributes do
        { :weight => 10.0 }
      end
    end

    Sham.config(Item, :large) do |c|
      c.attributes do
        { :weight => 100.0 }
      end
    end

Alternative shams can be invoked by passing their name into the `sham!` command.

    Item.sham!(:small, :quantity => 100)
    Item.sham!(:large, :build, :quantity => 0)

## Empty Shams

Sometimes you simply want to be able to sham an object without passing any
default options. Sham makes this easy by providing an `empty` configuration.

    # in sham/user.rb
    Sham.config(User) do |c|
      c.empty
    end

Empty configurations behave just like empty hashes. That means you can simply
pass your own attributes in when shamming the class.

    User.sham!
    User.sham!(:name => 'John Doe')

For parameter based initializers you can create empty configurations using the
`no_args` option.

    Sham.config(User){ |c| c.no_args }

## Nested Shamming

Sometimes you want one sham to be responsible for creating additional shams when
it is initialized. For instance, a `LineItem` might require an `Item` to be
considered a valid object. Sham makes this kind of nested sham very easy to
configure, and allows you to overwrite the 'sub-object' during initialization.

    # in sham/line_item_sham.rb
    Sham.config(LineItem) do |c|
      c.attributes do
        { :item => Sham::Nested.new(Item) }
      end
    end

The nested shams will automatically be invoked and can be overwritten during
initialization:

    LineItem.sham!
    LineItem.sham!(:item => Item.sham!(:weight => 100))


## Subclass Shams

Sham plays well with subclassing. That means shams defined on parent classes
will be available to child classes as well:

    Sham.config(Person) do |c|
      c.empty
    end

    class Person; end
    class Employee < Person; end

    Employee.sham!

You can also define different shams for your subclasses instead of relying on
the parent object.

## Reloading Shams with Spork

[Spork](https://rubygems.org/gems/spork) is a great gem that creates a
Distributed Ruby environment that you can run your RSpec and Cucumber tests
against. If you are using Rails it is often necessary to re-load your models and
controllers between Spork test runs so that the Spork DRB picks up your latest
model changes. This is usually accomplished using a Spork 'each run' block. This
block of code gets executed before each test run. If you want to be able to
reload your shams with Spork all you need to do is add a
`Sham::Config.activate!` line to this block after you have re-loaded your models
and controllers.

    Spork.each_run do
      Sham::Config.activate!
    end if Spork.using_spork?

This change will cause sham to be re-loaded so that you can continue to use it
with Spork. If you take this approach it's important to remove the call to
`Sham::Config.activate!` from your `test.rb` or `application.rb` file.

## Build Status [![Build Status](https://secure.travis-ci.org/panthomakos/sham.png)](http://travis-ci.org/panthomakos/sham)
