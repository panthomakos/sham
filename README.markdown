# Sham

Lightweight flexible factories for Ruby on Rails testing.

## Installation

    gem install sham

## Getting Started

Create a sham file for each of your models:

    # in sham/user.rb
    Sham.config(User) do |c|
      c.attributes do
        { :name => "Sample User" }
      end
    end

To load your shams you can either include the files individually, or define
your shams directly in your test file. Sham also provides a helper function to
load shams under the sham directory. To load all your shams add the following to
your application.rb or test.rb file:

    config.after_initialize do
      Sham::Config.activate!
    end

To enable all Shams in cucumber, add the following to your
features/support/env.rb file:

    require 'sham'
    Sham::Config.activate!

You can now "sham" your models and pass additional attributes at creation:

    User.sham!
    User.sham!(:name => "New Name")
    User.sham!(:age => 23)

You can use sham to build models without automatically saving them as well:

    user = User.sham!(:build, :name => "I have not been saved")
    user.save

## RSpec Example

Here is an example of testing validations on an ActiveRecord::Base class using
Sham and RSpec.

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

## Alternative Shams

You can easily define alternative sham configurations:

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

These can be invoked using:

    Item.sham!(:small, :quantity => 100)
    Item.sham!(:large, :build, :quantity => 0)

## Empty Shams

You can easily define empty shams using the empty function:

    # in sham/user.rb
    Sham.config(User) do |c|
      c.empty
    end

This can be invoked using:

    User.sham!

## Nested Shamming

You can nest shammed models inside others:

    # in sham/line_item_sham.rb
    Sham.config(LineItem) do |c|
      c.attributes do
        { :item => Sham::Base.new(Item) }
      end
    end

The nested shams will automatically be invoked and can be overridden during a
sham call:

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

## Reloading Shams with Spork

[Spork](https://rubygems.org/gems/spork) is a great gem that creates a
Distributed Ruby environment that you can run your RSpec and Cucumber tests
against. If you are using Rails it is often necessary to re-load your models and
controllers between Spork test runs so that the Spork DRB picks up your latest
model changes. This is usually accomplished using a Spork 'each run' block. This
block of code gets executed before each test run. If you want to be able to
reload your shams with Spork all you need to do is add a Sham::Config.activate!
line to this block after you have re-loaded your models and controllers.

    Spork.each_run do
      ActiveSupport::Dependencies.clear
      ActiveRecord::Base.instantiate_observers
      Sham::Config.activate!
    end if Spork.using_spork?

This change will cause sham to be re-loaded so that you can continue to use it
with Spork.
