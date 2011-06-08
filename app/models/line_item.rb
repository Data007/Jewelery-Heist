module LineItemErrors
  %w(EmptyVariationId EmptySize EmptyQuantity).each do |err|
    eval("class #{err} < StandardError; end")
  end
end

class LineItem < ActiveRecord::Base
  include LineItemErrors
  
  include AddZombies
  include AddZombies::ZombieState
  
  # acts_as_audited
  
  belongs_to :variation
  belongs_to :order
  
  has_many :assets, :as => :attachable, :dependent => :destroy
  
  scope :taxable,       :conditions => {:taxable => true}
  scope :nontaxable,    :conditions => {:taxable => false}
  
  scope :refunded,      :conditions => {:refunded => true}
  scope :not_refunded,  :conditions => {:refunded => false}
  
  scope :services,      :conditions => {:is_service => true}
  scope :not_services,  :conditions => {:is_service => false}
  
  before_create :validate_price

  def validate_price
    raise EmptyVariationId, "You need a variation in order to have a line item" if self.variation_id == nil && self.is_quick_item != true
    raise EmptySize, "A line item must have a size" if self.size == nil
    raise EmptyQuantity, "You must have a quantity of 1 or more in order to have a line item" if self.quantity == nil
    
    self.price = self.is_quick_item ? self.price : self.variation.price
  end
  
  def total
    return 0 unless self.price
    return self.price unless self.quantity
    return self.price * self.quantity
  end
  
  def refund
    unless self.is_quick_item
      variation = self.variation
      variation.update_attributes :quantity => (variation.quantity + self.quantity)
      
      item = variation.item
      item.update_attributes :available => true
      
      line_id = self.id
    else
      line_id = self.quick_id
    end
    
    self.update_attributes :refunded => true
  end
end
