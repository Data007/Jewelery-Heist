class Payment
  include Mongoid::Document
  include Mongoid::Timestamps
  include MafiaConnections

  field :amount,       type: Float
  field :payment_type, type: String, default: 'cash'
  field :check_number, type: Integer
  field :custom_id

  embedded_in :order

  before_save :validate_amount

  def validate_amount
    self.amount = launder_money(self.amount)
  end

  def refund
    order.payments.create amount: -self.amount, payment_type: 'instorecredit', check_number: self.check_number 
  end

  class << self

    def payment_type_options
      [
        ["Cash",             'cash'],
        ["Check",            'check'],
        ["Paypal",           'paypal'],
        ["Instore Credit",   'instorecredit'],
        ["Master Card",      'mastercard'],
        ["Visa",             'visa'],
        ["American Express", 'americanexpress'],
        ["Discover",         'discover'],
      ]
    end

  end

end
