class Payment < ActiveRecord::Base
  belongs_to :payment_type
  belongs_to :order
  
  default_scope :order => "created_at DESC"
end
