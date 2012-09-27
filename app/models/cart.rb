class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  
  field :first_name
  field :last_name
  field :email
  field :phone

  belongs_to  :user
  embeds_many :line_items
  embeds_one  :shipping_address, cascade_callbacks: true

end
