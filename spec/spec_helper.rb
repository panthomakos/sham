require 'bundler'
Bundler.require(:default)

SPEC_DIR = File.join(File.dirname(File.expand_path(__FILE__)), 'root')

class User
  attr_accessor :attributes

  def initialize attributes = {}
    self.attributes = attributes
  end

  def self.create attributes = {}
    new(attributes)
  end

  def [] attribute
    attributes[attribute]
  end
end

Sham.config(User) do |c|
  c.attributes do
    {
      name: Sham.string!,
      email: "#{Sham.string!}@gmail.com",
      identifier: 100
    }
  end
end

Sham.config(User, :super) do |c|
  c.attributes do
    { identifier: 200 }
  end
end

class Profile < User; end

Sham.config(User, :with_profile) do |c|
  c.attributes do
    { profile: Sham::Base.new(Profile) }
  end
end
Sham.config(Profile){ |c| c.empty }
