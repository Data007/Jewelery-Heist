class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  

  embedded_in :user
  embeds_many :items
end
