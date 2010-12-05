# Sham

Lightweight flexible factories for Ruby on Rails testing.

## Installation

    gem install sham

## Getting Started

Create a sham file for each of your models:

    # in sham/user_sham.rb
    class User::Sham
        def self.options
            { :name => "Sample User" }
        end
    end

To enable Sham in a particular environment, add the following to your environment.rb or test.rb file:

    config.after_initialize do
        Sham::Config.activate!
    end
    
To enable Sham in cucumber, add the following to your features/support/env.rb file:

    require 'sham'
    Sham::Config.activate!    

You can now "sham" your models and pass additional attributes at creation:

    User.sham!
    User.sham! :name => "New Name"
    User.sham! :age => 23
    
You can use sham to build models without saving them as well:

    user = User.sham! :build, :name => "I have not been saved"
    user.save
    
## RSpec Example

Here is an example of testing validations on an ActiveRecord::Base class using Sham and RSpec.

    # in app/models/item.rb
    class Item < ActiveRecord::Base
        validates_numericality_of :quantity, :greater_than => 0
    end

    # in sham/item_sham.rb
    class Item::Sham
        def self.options
            { :quantity => 1 }
        end
    end

    # in spec/models/item_spec.rb
    describe Item do
        it "should not allow items with a negative price" do
            item = Item.sham :build, :quantity => -1
            item.valid?.should be_false
        end
        
        it "should allow items with a positive quantity" do
            item = Item.sham :build, :quantity => 10
            item.valid?.should be_true
        end
    end
    
## Shamming Alternatives

You can add other alternative variations to the default "sham!" functionality:

    # in sham/item_sham.rb
    class Item::Sham
        def self.options
            { :weight => 1.0 }
        end
        
        def self.large_options
            { :weight => 100.0 }
        end
    end
    
These can be invoked using:

    Item.sham_alternate! :large, :quantity => 100
    Item.sham_alternate! :large, :build, :quantity => 0
    
## Nested Shamming

You can nest shammed models inside others:

    # in sham/line_item_sham.rb
    class LineItem::Sham
        def self.options
            { :item => Sham::Base.new(Item) }
        end
    end

The nested shams will automatically be invoked and can be overridden during a sham:

    LineItem.sham!
    LineItem.sham! :item => Item.sham!(:weight => 100)