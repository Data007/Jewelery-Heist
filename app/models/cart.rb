class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  
  field :first_name
  field :last_name
  field :email
  field :phone
  field :current_stage

  attr_accessor :shipping_address_id

  belongs_to  :user
  embeds_many :line_items
  embeds_one  :payment
  embeds_one  :credit_card
  embeds_one  :shipping_address
  embeds_one  :billing_address

  accepts_nested_attributes_for :line_items

  validates :email, presence: true, format: {with: /^\w+[\w\+\-.]+@[\w\-.]+.[\w]{2,4}$/, message: "%{value} is not a proper email"}, if: :current_stage_progressing

  validates :phone, presence: true, format: {with: /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[ ]?[-. ]?[ ]?([0-9]{4})$/, message: "%{value} is not a proper phone number. Example: (231)775-1289"}, if: :current_stage_progressing
  validates :first_name, presence: true, if: :current_stage_progressing
  validates :last_name, presence: true, if: :current_stage_progressing

  before_save :set_shipping_address

  def handling
    return 5
  end

  def add_item(item, options={})
    line_items.create(options.merge!(item: (item.is_a?(Item) ? item : Item.find(item))))
  end

  private
    def current_stage_progressing
      exclude_stages = ['show', 'checkout']
      current_stage.present? && !exclude_stages.include?(current_stage)
    end

    def set_shipping_address
      return true unless shipping_address_id

      address = User.all
        .map(&:addresses).flatten.compact
        .select do |address|
          address.id.to_s == shipping_address_id
        end.first
      self.shipping_address = address.clone if address
    end
end
