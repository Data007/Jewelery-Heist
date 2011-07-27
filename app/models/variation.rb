class Variation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :price,    type: Float,   default: 0.0
  field :quantity, type: Integer, default: 1

  embedded_in :item
end
