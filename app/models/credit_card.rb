class CreditCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  embedded_in :user

  field :number
  field :date
  field :ccv_code
  field :name_on_card
end
