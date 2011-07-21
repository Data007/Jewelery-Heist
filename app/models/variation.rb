class Variation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :price, type: Float, default: 0.0
end
