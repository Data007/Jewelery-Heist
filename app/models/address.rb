class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address_1
  field :address_2
  field :city
  field :province
  field :postal_code
  field :country, :default => 'US'

  embedded_in :user
  embedded_in :order
end
