class CreditCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  before_save :check_card_number

  embedded_in :user
 
  field :number,   type: Integer
  field :date
  field :ccv_code
  field :name_on_card

  validates_length_of :number, minimum: 16, maximum: 16
  
  private

  def check_card_number
    number.to_s.length == 16
  end
end
