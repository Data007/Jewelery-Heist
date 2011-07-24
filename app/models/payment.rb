class Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount,       type: Float
  field :payment_type, type: String, default: 'cash'
  field :check_number, type: Integer

  embedded_in :order

  class << self

    def payment_type_options
      [
        ["Cash",             'cash'],
        ["Check",            'check'],
        ["Paypal",           'paypal'],
        ["Instore Credit",   'instore credit'],
        ["Master Card",      'master card'],
        ["Visa",             'visa'],
        ["American Express", 'american express'],
        ["Discover",         'discover']
      ]
    end

  end

end
