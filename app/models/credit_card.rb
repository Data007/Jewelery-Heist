class CreditCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :number,   type: Integer
  field :date
  field :ccv_code
  field :name_on_card

  embedded_in :user
end
