class LineItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :quantity,      type: Integer, default: 1
  field :price,         type: Float
  field :taxable,       type: Boolean, default: false
  field :is_service,    type: Boolean, default: false
  field :is_quick_item, type: Boolean, default: false
  field :refunded,      type: Boolean, default: false
  field :name
  field :description
  field :quick_id
  field :size


  embeds_one  :variation
  embedded_in :order

  before_save :validate_price

  def total
    quantity * price
  end

  def validate_price
    self.price = variation.price if price.blank?
  end
end
