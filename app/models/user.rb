require 'digest/sha2'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :emails,       type: Array,   default: []
  field :phones,       type: Array,   default: []
  field :login
  field :password_hash
  field :is_active,    type: Boolean, default: false
  field :role,                        default: 'public'
  field :name
  field :company
  field :designer,     type: Boolean, default: false
  field :custom_id

  field :pretty_id,    type: Integer
  sequence :pretty_id

  embeds_many :addresses
  embeds_many :orders

  accepts_nested_attributes_for :addresses

  attr_accessor :password, :password_confirmation, :new_password, :old_password

  validates :name, presence: true, on: :create

  before_save :generate_password_hash

  # Scopes
  scope :workers,     where(:role.ne => 'public')
  scope :designers,   where(designer: true)
  scope :open_orders, -> { where('orders.purchased' => false) }

  class << self

    def full_search(user_query)
      return all unless user_query
      find_address = user_query.delete(:address) if (user_query[:address] && !user_query[:address].blank?)
      find_phone   = Regexp.new(user_query.delete(:phone)) if (user_query[:phone] && !user_query[:phone].blank?)
      find_email   = Regexp.new(user_query.delete(:email)) if (user_query[:email] && !user_query[:email].blank?)

      user_query.each { |(key, value)| user_query.delete(key.to_sym) if value.blank? }
      user_query = user_query.inject([]) do |hashes, (key, value)|
        hashes << {key.to_sym => Regexp.new(value)}
        hashes << {key.to_sym => Regexp.new(value.capitalize)}
        hashes << {key.to_sym => Regexp.new(value.upcase)}
        hashes << {key.to_sym => Regexp.new(value.downcase)}
      end

      if find_address
        new_find_address = {}
        find_address.each { |(key, value)| new_find_address["addresses.#{key}"] = Regexp.new(value.upcase) unless value.blank?}
        find_address = new_find_address
      end

      result = any_of(*user_query) unless user_query.empty?
      result = (result ? result.and(find_address) : where(find_address)) if find_address && !find_address.empty?
      result = (result ? result.any_in(phones: [find_phone]) : any_in(phones: [find_phone])) if find_phone
      result = (result ? result.any_in(emails: [find_email]) : any_in(emails: [find_email])) if find_email
      return result
    end

    def create_from_search_params(user_query)
      if user_query
        address = user_query.delete(:address) if (user_query[:address] && !user_query[:address].blank?)
        phone   = user_query.delete(:phone)   if (user_query[:phone]   && !user_query[:phone].blank?)
        email   = user_query.delete(:email)   if (user_query[:email]   && !user_query[:email].blank?)

        user = User.find_or_create_by(user_query)
        user.addresses.find_or_create_by address if address
        user.emails << email if (email && user.emails.include?(email))
        user.phones << phone if (phone && user.phones.include?(phone))
      else
        user = User.new
        user.save(validate: false)
      end

      return user
    end

    def find_order(order_id)
      where('orders.pretty_id' => order_id.to_i).
      map {|user| user.orders.where(pretty_id: order_id)}.
      flatten.first
    end

  end
  ##

  def open_order
    orders.where(purchased: false).first
  end
  
  def open_web_order
    orders.where(purchased: false, location: 'website', staging_type: 'purchase').first
  end

  def closed_orders
    orders.where(purchased: true)
  end
  
  # Authentication
  def generate_new_password
    new_password = User.generate_plain_token
    password = password_confirmation = new_password
    save
    return new_password
  end

  def generate_password_hash
    if (password.present? && password_confirmation.present?)
      if password == password_confirmation
        self.password_hash = self.class.send(:hash_password, password)
      else
        errors.add :password_confirmation, 'does not match the password'
      end
    end
  end

  def is_admin?
    role == 'admin' ? true : false
  end

  def is_employee?
    role == 'employee' ? true : false
  end

  def is_worker?
    (role == 'employee' || role == 'admin') ? true : false
  end

  class << self

    def generate_plain_token
      words = %w{ cat shovel cloud find pass risk taco glass dog bottle can bowl spoon cheese chili fork cup fish chips }
      new_pass = "%s%s" % [ words[ rand( words.length ) ], words[ rand( words.length ) ] ]
      return new_pass
    end

    def generate_password_hash
      hash_password(Time.now.to_s)
    end

    def hash_password(password)
      Digest::SHA256.hexdigest password
    end

    def authorize(login, password)
      user = where(login: login, password_hash: hash_password(password)).first
      (user && user.is_active) ? user : nil
    end

  end
  ##

  # Financial
  def purchased_orders
    orders.where(purchased: true)
  end

  def total_spent
    purchased_orders.map(&:total).sum
  end

  def total_credits
    purchased_orders.map(&:credits_total).sum
  end

  def total_payments
    purchased_orders.map(&:payments_total).sum
  end

  def total_balance
    purchased_orders.map(&:balance).sum
  end
  ##

  def validate_addresses
    required_fields = %w(address_1 city province postal_code country)
    new_addresses   = addresses
    new_addresses   = new_addresses.reject do |address|
      required_fields.collect do |required_field|
        eval("address.#{required_field}").present?
      end.flatten.compact.include?(false)
    end
    self.addresses = new_addresses
  end

  def last_shipping_address
    return nil unless closed_orders.present?
    return closed_orders.last.address
  end

  # Permissions
  def may_destroy_item?
    return (role == 'admin')
  end
  ##
end
