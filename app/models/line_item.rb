class LineItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  include MafiaConnections

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
  embeds_one  :item
  embedded_in :order

  scope :taxable,    where(taxable: true)
  scope :nontaxable, where(taxable: false)

  before_save :validate_price

  def total
    (quantity.present? ? quantity : 1) * (price.present? ? price : 0)
  end

  def validate_price
    unless is_quick_item?
      if price.blank?
        self.price = variation.present? ? variation.price : 0
      end
    end

    self.price = launder_money(self.price).to_f
  end

  def remove_item(refund=false)
    unless self.is_quick_item
      item = Item.find(self.item.id)

      if refund
        item.update_attributes(quantity: (item.quantity + self.quantity), available: true)
        order.payments.create(
          payment_type: 'instorecredit',
          amount:       -price
        )
      end
      
      line_id = self.id
    else
      line_id = self.quick_id
    end
  end

  def refund
    remove_item true
    
    self.update_attribute :refunded, true
  end
end
