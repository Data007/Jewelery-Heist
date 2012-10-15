class CreditCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :number,   type: Integer
  field :month
  field :year
  field :ccv
  field :name

  embedded_in :user

  validates :number, presence: true
  validates :ccv, presence: true
  validates :name, presence: true
  validate :custom_validate
  
  def custom_validate
    errors.add(:number, "Number cannot be nil") unless self.ccv.present?
  end
end
