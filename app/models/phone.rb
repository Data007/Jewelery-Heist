# NOTE: make a rake task to migrate old array phones to the model phone

class Phone
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :number

  embedded_in :user

  validates :number, format: {with: /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[ ]?[-. ]?[ ]?([0-9]{4})$/, message: '%{value} is not a proper phone number. Example: (231)775-1289'}
end

