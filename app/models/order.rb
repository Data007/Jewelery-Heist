class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :refunded,       type: Boolean, default: false
  field :ship,           type: Boolean, default: false
  field :purchased,      type: Boolean, default: false
  field :handed_off,     type: Boolean, default: false
  field :custom_id,      type: Integer
  field :clerk_id,       type: Integer
  field :shipping_option
  field :notes
  field :location,                      default: 'instore'
  field :staging_type,                  default: 'purchase'

  field :pretty_id,    type: Integer
  sequence :pretty_id  

  embedded_in :user
  embeds_many :line_items
  embeds_many :payments
  embeds_one  :address
  embeds_one  :ticket

  before_save  :set_address
  after_create :setup_ticket

  DUEDATES = [
    "same day",
    "1 week",
    "2 weeks",
    "3 weeks",
    "4 weeks",
    "5 weeks",
    "6 weeks",
    "7 weeks",
    "8 weeks",
    "9 weeks",
    "10 weeks",
    "11 weeks",
    "12 weeks"
  ]
  

  def setup_ticket
    self.ticket  = generate_ticket_from_order
    self.ship    = true if self.location == "website"
    self.save
  end
  
  def set_address
    self.address = user.addresses.first unless address
  end

  def due_dates
    return DUEDATES.collect {|date| [date, date]}
  end

  def has_valid_shipping_address?
    true
  end

  def full_shipping
    # US Ground $0
  	# US Second $10 < $300 > $0
  	# US Express $20 < $500 > $0
  	# Int Priority $30 < $500 > $0
  	# Int Second $70 < $1000 > $0
  	# Int Overnight $100 < $1500 > $0
  	# Duties are the responsibility of the customer
    options = [
      ["US Ground", 0, 0],
  	  ["US Second Day", 10, 300],
  	  ["US Express", 20, 500],
  	  ["Australia Regular", 30, 500],
      ["Australia Priority (2 to 5 days)", 100, 1000],
  	  ["New Zealand Regular", 30, 500],
      ["New Zealand Priority (2 to 5 days)", 100, 1000],
  	  ["International Priority", 30, 500],
	    ["International Second Day", 70, 1000],
	    ["International Overnight", 100, 1500]
    ]
    return options
  end  

  def shipping_by_country(country="US")
    if country == "US"
      options = [
    	  ["US Ground", 0, 0],
    	  ["US Second Day", 10, 300],
    	  ["US Express", 20, 500]
    	]
  	elsif (country == "AT" || country == "at" || country == "AUS" || country == "aus" || country == "Australia" || country == "australia")
  	  options =[
  	    ["Australia Regular", 30, 500],
	      ["Australia Priority (2 to 5 days)", 100, 1000]
	    ]
	  elsif (country == "NZ" || country == "nz" || country == "New Zealand" || country == "new zealand")
  	  options =[
  	    ["New Zealand Regular", 30, 500],
	      ["New Zealand Priority (2 to 5 days)", 100, 1000]
	    ]
  	else
  	  options =[
  	    ["International Priority", 30, 500],
	      ["International Second Day", 70, 1000],
	      ["International Overnight", 100, 1500]
	    ]
    end
    return options
  end

  def shipping_options
    options = shipping_by_country(address.country).collect do |shipping_option|
  	  ["#{shipping_option[0]} #{subtotal >= shipping_option[2] ? "Free Upgrade" : '$' + shipping_option[1].to_s + '.00'}", shipping_option[0]]
	  end
	  return options
  end

  def shipping_cost
    cost = 0
    full_shipping.each do |option|
      if self.shipping_option == option[0]
        cost = self.subtotal >= option[2] ? 0 : option[1]
      end
    end
    return cost
  end

  def add_line_item(new_line_item)
    line_items << ((new_line_item.class == LineItem) ? new_line_item : LineItem.new(new_line_item))
  end

  def add_item(variation, options={})
    add_line_item(options.merge({
      variation: variation,
        taxable: true
    }))
  end

  def add_payment(amount, payment_type='cash')
    payments.create amount: amount, payment_type: payment_type
  end  

  def purchase
    update_attribute :purchased, true
  end

  def subtotal
    line_items.map(&:total).sum
  end

  def tax
    line_items.where(taxable: true).map(&:total).sum * 0.06
  end

  def total
    subtotal + tax + shipping_cost
  end

  def payments_total
    payments.where(:amount.gt => 0).map(&:amount).sum
  end

  def paid
    payments_total - credits_total
  end

  def credits_total
    -payments.where(payment_type: /credit/, :amount.lt => 0).map(&:amount).sum
  end

  def balance
    total - paid
  end

  def hand_off
    self.line_items.each do |line_item|
      item = line_item.variation.parent_item
      line_item.variation.update_attributes quantity: line_item.variation.quantity - 1 if line_item.variation.quantity > 0
      if item.one_of_a_kind
        item.update_attributes available: false
      end
    end
    
    self.ticket.current_stage = "handed off"
    self.ticket.next_stage
    self.ticket.save
    
    self.update_attributes handed_off: true, purchased: true
  end
  
  ## Clerk stuff
  def clerk
    User.find(clerk_id)
  end

  def clerk=(user)
    clerk_id = user.id
  end
  ##

  class << self
    
    def find_line_item(line_item_id)
      User.where('orders.line_items._id' => line_item_id).
      map    { |user     | user.orders                       }.flatten.
      map    { |order    | order.line_items                  }.flatten.
      select { |line_item| line_item.id.to_s == line_item_id }.flatten.
      first
    end

    def purchase
      User.where('orders.staging_type' => 'purchase').
      map { |user| user.orders }.flatten
    end

    def repair
      User.where('orders.staging_type' => 'repair').
      map { |user| user.orders }.flatten
    end

    def custom
      User.where('orders.staging_type' => 'custom').
      map { |user| user.orders }.flatten
    end

    def payments_made
      User.all.
      map { |user| user.orders }.flatten
    end

  end

private

  def generate_ticket_from_order
    return Ticket.new(:kind => "#{self.location} #{self.staging_type}")
  end

end
