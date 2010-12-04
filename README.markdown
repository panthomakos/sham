# Sham

Flexible factories for Ruby on Rails testing in any environment.

## Installation

  gem install sham

## Getting Started

Create a sham file for each of your models:

  # in sham/user_sham.rb
  class Sham::ItemSham < Sham::Core
    def self.options
      { :name => "Sample User" }
    end
  end

Note: Sham is automatically enabled in test and cucumber environments.  You can manually enable it or disable
it by using the enable! and disable! commands in your environment.rb or test.rb files:

  Sham::Config.enable!
  Sham::Config.disable!

You can now "sham" your models and pass additional attributes at creation:

  User.sham!
  User.sham! :name => "New Name"
  User.sham! :age => 23