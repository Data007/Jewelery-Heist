class LineItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :quantity, type: Integer, default: 1
  field :price,    type: Float

  embeds_one :variation

  before_save :validate_price

  def total
    quantity * price
  end

  def validate_price
    self.price = variation.price if price.blank?
  end
end
