class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :emails, :type => Array, :default => []
  field :phones, :type => Array, :default => []

  embeds_many :addresses
end
