class LineItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

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
  field :custom_id

  field :pretty_id,    type: Integer
  sequence :pretty_id  

  embeds_one  :variation
  embedded_in :order

  scope :taxable,    where(taxable: true)
  scope :nontaxable, where(taxable: false)

  before_save :validate_price

  def total
    quantity * price
  end

  def validate_price
    unless is_quick_item?
      self.price = (price.blank? && variation.present?) ? variation.price : 0
    end
  end

  def refund
    unless self.is_quick_item
      variation = self.variation
      variation.update_attribute :quantity, (variation.quantity + self.quantity)
      
      item = variation.parent_item
      item.update_attribute :available, true
      
      line_id = self.id
    else
      line_id = self.quick_id
    end
    
    self.update_attribute :refunded, true
  end
end
