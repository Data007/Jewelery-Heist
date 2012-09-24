class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  
  belongs_to  :user
  embeds_many :line_items
end
