class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  
  field :first_name
  field :last_name
  field :email
  field :phone
  field :current_stage
  field :shipping_type, default: Fedexer::SHIPPING_OPTIONS.first

  attr_accessor :shipping_address_id

  belongs_to  :user
  has_one     :order
  embeds_many :line_items
  embeds_one  :payment
  embeds_one  :credit_card
  embeds_one  :shipping_address
  embeds_one  :billing_address

  accepts_nested_attributes_for :line_items, :billing_address, :credit_card

  validates :email, presence: true, format: {with: /^\w+[\w\+\-.]+@[\w\-.]+.[\w]{2,4}$/, message: "%{value} is not a proper email"}, if: :current_stage_progressing

  validates :phone, presence: true, format: {with: /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[ ]?[-. ]?[ ]?([0-9]{4})$/, message: "%{value} is not a proper phone number. Example: (231)775-1289"}, if: :current_stage_progressing
  validates :first_name, presence: true, if: :current_stage_progressing
  validates :last_name, presence: true, if: :current_stage_progressing

  before_save :set_shipping_address

  def handling
    return 5
  end

  def process_cart
    #TODO create a order for the cart
    create_order_from_cart  
  end

  def create_order_from_cart
    order = Order.new
    order.user = self.user
    order.line_items = self.line_items
    order.payments = self.payment
    order.address = self.shipping_address
    order.purchased_at = DateTime.now
    order.shipping_option = self.shipping_type
    order.location = 'website'
    order.save!

    self.order = order
    self.save!
  end
  
  def full_name
    first_name + ' ' + last_name
  end

  def add_item(item, options={})
    line_items.create(options.merge!(item: (item.is_a?(Item) ? item : Item.find(item))))
  end

  def get_rate shipping_type='FEDEX_GROUND'
    shipping_type = self.shipping_type ? self.shipping_type : shipping_type
    Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient("#{self.first_name} #{self.last_name}", self.shipping_address, self.phone), Fedexer.sample_package, shipping_type, Fedexer.default_shipping_details) 
  end

  def shipping_options
    Fedexer::SHIPPING_OPTIONS.collect do |shipping_option|
      self.shipping_type = shipping_option
      self.save
      rate = self.get_rate(shipping_option).total_net_charge
      {name: shipping_option, total_net_charge: rate}
    end
  end

  def tax
    (line_items.where(taxable: true).map(&:total).sum * 0.06).round(2)
  end
  
  def subtotal
    (line_items.map(&:total).sum).round(2)
  end

  def total
    total = subtotal + tax + get_rate(shipping_type).total_net_charge.to_f
    '$' + total.round(2).to_s
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
