class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  field :refunded,       type: Boolean, default: false
  field :ship,           type: Boolean, default: false
  field :purchased,      type: Boolean, default: false
  field :custom_id,      type: Integer
  field :clerk_id,       type: Integer
  field :shipping_option
  field :notes
  field :location,                      default: 'instore'
  field :staging_type,                  default: 'purchase'

  embedded_in :user
  embeds_many :line_items
  embeds_many :payments
  embeds_one  :address

  before_save :set_address

  def set_address
    self.address = user.addresses.first unless address
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
    subtotal + tax
  end

  def payments_total
    payments.where(:amount.gt => 0).map(&:amount).sum
  end

  def paid
    payments_total
  end

  def credits_total
    -payments.where(payment_type: /credit/, :amount.lt => 0).map(&:amount).sum
  end

  def balance
    total - (payments_total + credits_total)
  end

  ## Clerk stuff
  def clerk
    User.find(clerk_id)
  end

  def clerk=(user)
    clerk_id = user.id
  end
  ##
end
