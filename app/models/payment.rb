class Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount,       type: Float
  field :payment_type, type: String, default: 'cash'
  field :check_number, type: Integer
  field :custom_id

  embedded_in :order

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
        ["Discover",         'discover']
      ]
    end

  end

end
