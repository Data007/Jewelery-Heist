class CreditCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :number,   type: Integer
  field :date
  field :ccv_code
  field :name_on_card

  embedded_in :user

  validates :number, presence: true
  validate :custom_validate
  
  def custom_validate
    if self.ccv_code == ''  
      errors.add(:number, "Number cannot be nil") 
    end
  end
end
