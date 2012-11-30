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

  validates :address_1, presence: {message: "Address line 1 can't be blank."}
  validates :city, presence: true
  validates :postal_code, presence: {message: "Postal Code can't be blank"}

  def to_single_line
    address  = "#{address_1}, "
    address += "#{address_2}, " if address_2.present?
    address += "#{city}, #{province} #{postal_code} #{country}"
    return address
  end
end
