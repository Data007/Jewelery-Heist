class Address < ActiveRecord::Base
  belongs_to :user
  
  class << self
    def from_hash(address_hash)
      address = Address.find_by_address_1(address_hash[:address_1])
      address = address ? address : Address.create(address_hash)
      address.update_attributes address_hash
      return address
    end
  end
end
