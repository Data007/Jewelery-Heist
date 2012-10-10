class CreditCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :number,   type: Integer
  field :month
  field :year
  field :cvv
  field :name

  embedded_in :user

  validates :number, presence: true
  validate :custom_validate
  
  def custom_validate
    if self.ccv_code == ''  
      errors.add(:number, "Number cannot be nil") 
    end
  end
end
