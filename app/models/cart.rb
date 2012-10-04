class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  
  field :first_name
  field :last_name
  field :email
  field :phone
  field :current_stage

  belongs_to  :user
  embeds_many :line_items
  embeds_one  :payment
  embeds_one  :shipping_address
  embeds_one  :billing_address

  accepts_nested_attributes_for :line_items

  validates :email, presence: true, format: {with: /^\w+[\w\+\-.]+@[\w\-.]+.[\w]{2,4}$/, message: "%{value} is not a proper email"}, if: 'current_stage.present?'

  validates :phone, presence: true, format: {with: /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[ ]?[-. ]?[ ]?([0-9]{4})$/, message: "%{value} is not a proper phone number. Example: (231)775-1289"}, if: 'current_stage.present?'
  validates :first_name, presence: {message: "First Name can't be blank"}, if: 'current_stage.present?'
  validates :last_name, presence: {message: "Last Name can't be blank"}, if: 'current_stage.present?'


  public
    def handling
      return 5
    end
end
