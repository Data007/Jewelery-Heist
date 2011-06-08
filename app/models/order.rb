module OrderErrors
  %w(InvalidLocation InvalidStagingType MissingClerk BalanceRemaining).each do |err|
    eval("class #{err} < StandardError; end")
  end
end

class Order < ActiveRecord::Base
  include OrderErrors
  include AddZombies
  include AddZombies::ZombieState
  
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
  
  # force test
  
  default_scope :order => "purchased_at DESC, city DESC, province DESC, country DESC, location DESC"
  
  # acts_as_audited
  
  has_many :line_items
  has_many :variations, :through => :line_items
  has_many :payments
  has_one :ticket, :dependent => :destroy
  belongs_to :user
  belongs_to :clerk, :class_name => "User", :foreign_key => "clerk_id"
  
  accepts_nested_attributes_for :line_items
  
  scope :website,       :conditions => {:location => "website"}
  scope :instore,       :conditions => {:location => "instore"}
  scope :repairs,       :conditions => {:staging_type => "repair"}
  
  scope :purchase,      :conditions => {:staging_type => "purchase"}
  scope :repair,        :conditions => {:staging_type => "repair"}
  scope :custom,        :conditions => {:staging_type => "custom"}
  
  scope :not_processed, :conditions => {:ghost => false, :handed_off => false}, :order => "updated_at DESC"
  scope :created_older_than, lambda { |timestamp| { :conditions => ["created_at <= ?", timestamp] } }
  scope :updated_older_than, lambda { |timestamp| { :conditions => ["updated_at <= ?", timestamp] } }
  scope :purchased_newer_than, lambda { |timestamp| { :conditions => ["updated_at >= ?", timestamp] } }
  scope :purchased_in_year, lambda { |year|
    { :conditions => ["purchased_at >= ? AND purchased_at <= ?", DateTime.parse("1-1-#{year}").beginning_of_year, DateTime.parse("1-1-#{year}").end_of_year] } }
  
  scope :handed_off,    :conditions => {:handed_off => true}, :order => "updated_at DESC"
  scope :registered,    :conditions => "user_id IS NOT NULL"
  scope :unregistered,  :conditions => "user_id IS NULL"
  
  scope :payments_made, :joins => :payments, :group => self.column_names.collect {|n| "orders.#{n}"}.join(",")
  
  scope :refunded,      :conditions => {:refunded => true}
  scope :not_refunded,  :conditions => {:refunded => false}
  
  before_save  :set_staging_type
  after_create :set_country
  after_save   :finalize_contact_info

  def set_staging_type
    case self.location
      when "instore"
        valid_staging_types = %w(custom repair production purchase)
        
        raise MissingClerk if self.clerk_id == nil
        raise InvalidStagingType, "An order must have a staging type" if self.staging_type == nil
        raise InvalidStagingType, "The #{self.staging_type} is invalid for in store orders" unless valid_staging_types.include? self.staging_type
        
      when "website"
        valid_staging_types = %w(custom purchase)
        
        raise InvalidStagingType, "An order must have a staging type" if self.staging_type == nil
        raise InvalidStagingType, "The #{self.staging_type} is invalid for in store orders" unless valid_staging_types.include? self.staging_type
        
      else
        raise InvalidLocation, "This order can only be located in a store (instore) of on the website (website)"
    end
  end
  
  def set_country
    self.country = "US" if self.country == nil
    self.ticket = generate_ticket_from_order
    self.ship = true if self.location == "website"
    self.save
  end
  
  def finalize_contact_info
    force_ticket if self.ticket == nil
    rectify_contact_information
  end
  
  def rectify_contact_information
    return true unless user
    found_address = user.addresses.find_by_address_1_and_city_and_province_and_postal_code_and_country(
      address_1,
      city,
      province,
      postal_code,
      country
    )
    found_phone   = user.phones.find_by_number(phones)
    found_email   = user.emails.find_by_address(emails)
    
    unless found_address
      user.addresses.create({
        :address_1    => address_1,
        :address_2    => address_2,
        :city         => city,
        :province     => province,
        :postal_code  => postal_code,
        :country      => country
      }) if has_valid_shipping_address?
    end
    
    unless found_phone
      user.phones.create({:number => phones}) if phones.present?
    end
    
    unless found_email
      user.emails.create({:address => emails}) if emails.present?
    end
    return true
  end
  
  def due_dates
    return DUEDATES.collect {|date| [date, date]}
  end
  
  def due_date
    return self.due_at == "same day" ? self.created_at : self.created_at.advance(:weeks => self.due_at.split(" ")[0].to_i)
  end
  
  def images
    found_images = line_items.the_living.collect do |li|
      unless li.is_quick_item
        li.variation.assets.first.image if li.variation.assets.present?
      end
    end.flatten.compact
    return found_images
  end
  
  def has_valid_shipping_address?
    logger.debug "\n\n== Order Address: @order.is_valid_shipping_address? ==\n"
    %w(address_1 city province postal_code country).each do |field|
      field_value = eval("self.#{field}");
      logger.debug "\t#{field_value}"
      if field_value == "" or field_value == nil
        return false
      end
    end
    logger.debug "==\n\n"
    return true
  end
  
  def clear
    self.line_items.each {|line_item| line_item.destroy}
  end
  
  def refund
    self.line_items.each do |line_item|
      line_item.refund
    end
    
    self.ticket.current_stage = "restocked"
    self.update_attributes :refunded => true
    return true
  end
  
  def subtotal
    return safe_float(self.line_items.the_living.not_refunded.inject(0) {|total, line_item| total += line_item.total})
  end
  
  def taxable_subtotal
    return safe_float(self.line_items.taxable.the_living.not_refunded.inject(0) {|total, line_item| total += line_item.total})
  end
  
  def accepted_cards
    cards = [
      ["Master Card", "MasterCard"],
      ["Visa", "Visa"],
      ["American Express", "AmericanExpress"],
      ["Discover", "Discover"]
    ]
    return cards
  end
  
  def tax
    return safe_float(line_items.the_living.not_refunded.taxable.inject(0) {|total, line_item| total += line_item.total} * 0.06)
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
  
  def shipping_cost
    cost = 0
    full_shipping.each do |option|
      if self.shipping_option == option[0]
        cost = self.subtotal >= option[2] ? 0 : option[1]
      end
    end
    return cost
  end
  
  def total
    return self.ship ? safe_float(subtotal + tax + shipping_cost) : safe_float(subtotal + tax)
  end
  
  def paid
    return 0.0 unless self.payments
    return self.payments.length > 0 ? safe_float(self.payments.inject(0) {|total, payment| total += payment.amount.blank? ? 0.0 : payment.amount }) : 0
  end
  
  def total_with_tax
    return safe_float(subtotal + tax)
  end
  
  def balance
    return safe_float(total - paid)
  end
  
  def shipping_options
    options = nil
  	if self.has_valid_shipping_address?
  	  options = shipping_by_country(self.country).collect do |shipping_option|
  	    ["#{shipping_option[0]} #{self.subtotal >= shipping_option[2] ? "Free Upgrade" : '$' + shipping_option[1].to_s + '.00'}", shipping_option[0]]
	    end
	  end
	  return options
  end
  
  def address
    address = {}
    valid_address = true
    %w(address_1 address_2 city province postal_code country).each do |field|
      address[:"#{field}"] = eval("self.#{field}")
    end
    return address[:address_1] != nil ? address : nil
  end
  
  def hand_off
    raise BalanceRemaining, "This order can not continue with a remaining balance" unless self.balance == 0
    
    self.line_items.the_living.each do |line_item|
      item = line_item.variation.item
      line_item.variation.update_attributes :quantity => line_item.variation.quantity - 1 if line_item.variation.quantity > 0
      if item.one_of_a_kind
        item.update_attributes :available => false
      end
    end
    
    self.ticket.current_stage = "handed off"
    self.ticket.next_stage
    self.ticket.save
    
    ghost = self.location == "website" ? true : false
    self.update_attributes :handed_off => true, :ghost => ghost
  end
  
  def paid_off
    (payments.length > 0 && balance == 0)
  end
  
  private
    def safe_float(float)
      return 0.0 unless float
      return ("%.2f" % float).to_f
    end
    
    def force_ticket
      self.clerk_id = User.find_by_login("m3talsmith").id if (self.location == "instore" && self.clerk_id == nil)
      self.staging_type = "purchase" if self.staging_type == nil
      self.ticket = generate_ticket_from_order
      self.ticket.next_stage if self.handed_off
      self.save
    end
    
    def generate_ticket_from_order
      return Ticket.create(:kind => "#{self.location} #{self.staging_type}")
    end
end
