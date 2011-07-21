class Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount,       type: Float
  field :payment_type, type: String, default: 'cash'

  embedded_in :order
end
