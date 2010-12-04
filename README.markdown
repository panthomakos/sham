Sham
---

Sham provides flexible factories for Ruby on Rails testing in any environment.

Installation
---
gem install sham

Getting Started
---

Create a sham file for any model you want to create factories for:

flex/user_flex.rb
class Sham::ItemSham < Sham::Core
  def self.options
    { :name => "Sample User" }
  end
end

Sham is automatically enabled in test and cucumber environments.  You can manually enable it using:

Sham::Config.enable!

in your environment.rb or test.rb files.

You can now "sham" Users:

User.sham! => User :name => "Sample User"
User.sham! :name => "New Name" => User :name => "New Name"
User.sham! :age => 23 User :name => "Sample User", :age => 23