class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  include MafiaConnections

  field :refunded,          type: Boolean, default: false
  field :ship,              type: Boolean, default: false
  field :purchased,         type: Boolean, default: false
  field :handed_off,        type: Boolean, default: false
  field :show_wax,          type: Boolean, default: false
  field :custom_id,         type: Integer
  field :clerk_id,          type: Integer
  field :purchased_at,      type: DateTime
  field :due_at
  field :shipping_option
  field :notes
  field :repair_notes
  field :item_notes
  field :based_on_item_ids
  field :molds
  field :metals
  field :stones
  field :location,                      default: 'instore'
  field :staging_type,                  default: 'purchase'

  field :pretty_id,    type: Integer
  sequence :pretty_id  

  belongs_to  :user
  belongs_to  :cart
  embeds_many :line_items
  # TODO: create a migration script to move old order[:payments] into an invoice with processed payments
  embeds_many :invoices
  # TODO: create a migration script to move order[:address] into order.shipping_address
  embeds_one  :address
  embeds_one  :ticket
  embeds_one  :cart

  accepts_nested_attributes_for :address

  before_save  :set_shipping_address
  after_create :setup_ticket

  default_scope order_by([:pretty_id, :asc])

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
  
  def set_shipping_address
    self.address = self.address unless address
  end

  def due_dates
    return DUEDATES.collect {|date| [date, date]}
  end

  def due_date
    return self.due_at == "same day" ? self.created_at : self.created_at.advance(weeks: self.due_at.split(" ")[0].to_i)
  end

  def has_valid_shipping_address?
    shipping_address
  end

  def shipping_cost
  end

  def refund_line_item(line_item_id)
    line_item = line_items.find(line_item_id)
    if line_item
      line_item.refund
    end
  end

  def add_line_item(new_line_item)
    line_items << ((new_line_item.class == LineItem) ? new_line_item : LineItem.new(new_line_item))
  end

  def add_item(item, options={})
    add_line_item(options.merge({
           item: item,
        taxable: true,
          price: item.price,
       quantity: 1
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
    rates = Shipper.rates(Shipper.destination(address), Shipper.sample_packages)
    
    subtotal + tax + rates[shipping_option.to_sym][:price]
  end

  def payments_total
    invoices.map(&:payments)
      .flatten.compact
      .map(&:amount)
        .flatten.compact
        .sum
  end

  def paid
    payments_total - credits_total
  end

  def credits_total
    -invoices.map(&:payments)
      .flatten.compact
      .select do |payment|
        payment if payment.payment_type == 'credit' && payment.amount < 0.0
      end
        .flatten.compact
        .map(&:amount)
          .sum
    # -payments.where(payment_type: /credit/, :amount.lt => 0).map(&:amount).sum
  end

  def balance
    total - paid
  end

  def hand_off
    self.line_items.each do |line_item|
      unless line_item.is_quick_item?
        item = Item.find(line_item.item.id)
        item.update_attributes(quantity: (item.quantity - 1)) if item.quantity > 0
        if item.one_of_a_kind
          item.update_attributes available: false
        end
      end
    end

    begin
      self.shipping_address = user.addresses.last.clone unless self.shipping_address.present?
    rescue; end
    
    self.ticket.current_stage = "handed off"
    self.ticket.next_stage
    self.ticket.save

    self.save
    
    self.update_attributes handed_off: true, purchased: true, purchased_at: Time.now
  end

  def refund
    self.line_items.each do |line_item|
      line_item.refund
    end
    
    self.ticket.current_stage = "restocked"
    self.ticket.save
    self.update_attributes refunded: true
  end

  def validate_line_items
    line_items.each do |line_item|
      unless line_item.is_quick_item?
        if line_item.item
          line_item.destroy if     line_item.item.ghost
          line_item.destroy unless line_item.item.available
        end
      end
    end
  end
  
  ## Clerk stuff
  def clerk
    User.where(pretty_id: clerk_id)
  end

  def clerk=(user)
    clerk_id = user.pretty_id
  end
  ##

  class << self
    
    def find_line_item(line_item_id)
      User.where('orders.line_items.pretty_id' => line_item_id.to_i).
      map    { |user     | user.orders                              }.flatten.
      map    { |order    | order.line_items                         }.flatten.
      select { |line_item| line_item.pretty_id == line_item_id.to_i }.flatten.
      first
    end

    def all
      User.all.
      map(&:orders).flatten.compact
    end

    def purchase
      User.where('orders.staging_type' => 'purchase').
      map  { |user            | user.orders                             }.flatten.
      sort { |order_1, order_2| order_1.pretty_id <=> order_2.pretty_id }.reverse
    end

    def repair
      User.where('orders.staging_type' => 'repair').
      map  { |user            | user.orders                             }.flatten.
      sort { |order_1, order_2| order_1.pretty_id <=> order_2.pretty_id }.reverse
    end

    def custom
      User.where('orders.staging_type' => 'custom').
      map  { |user            | user.orders                             }.flatten.
      sort { |order_1, order_2| order_1.pretty_id <=> order_2.pretty_id }.reverse
    end

    def payments_made
      User.all.
      map  { |user            | user.orders                             }.flatten.
      sort { |order_1, order_2| order_1.pretty_id <=> order_2.pretty_id }.reverse
    end

  end

private

  def generate_ticket_from_order
    return Ticket.new(:kind => "#{self.location} #{self.staging_type}")
  end

end
