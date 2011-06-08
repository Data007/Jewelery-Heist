require "rubygems"
require "digest/sha2"

class User < ActiveRecord::Base
  # acts_as_audited :except => [:password]
  include AddZombies
  include AddZombies::ZombieState
  
  index do
    [name, phone]
  end
  
  has_role :default => :guest
  
  scope :active, :conditions => {:is_active => true}
  scope :in_active, :conditions => {:is_active => false}
  scope :customers, :conditions => {:role_name => "customer"}
  scope :employees, :conditions => {:role_name => "employee"}
  scope :managers,  :conditions => {:role_name => "manager"}
  scope :owners,    :conditions => {:role_name => "owner"}
  
  has_many :orders
  # has_many  :posts
  
  has_many :tickets, :foreign_key => :assigned_id
  has_many :owned_tickets, :class_name => "Ticket"
  has_many :addresses
  has_many :phones
  has_many :emails
  
  has_one :designer
  
  accepts_nested_attributes_for :orders
  accepts_nested_attributes_for :emails
  accepts_nested_attributes_for :phones
  accepts_nested_attributes_for :addresses
  
  # -- Validations --
    validates_uniqueness_of :login, :message => " already exists"
    # validates_uniqueness_of :email, :message => " address is already in use"
    validates_presence_of :name, :login, :password, :email, :message => " cannot be empty"
    validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => " must be valid, such as info@wexfordjewelers.com"
    
    validates_confirmation_of :password, :if => :can_change_password
    
    def can_change_password
      if !old_password.blank?
        if !new_password.blank?
          if !User.is_authentic(login, old_password)
            errors.add(nil, "Your current password was not entered correctly or is wrong. Please re-enter your current password and try again.")
            return false
          else
            self.password = new_password
            return true
          end
        else
          errors.add(nil, "You've left your new password blank. For security reasons, your password must be not be blank.")
          return false
        end
      else
        return true
      end
    end
  # -- 
  
  attr_accessor :new_password
  attr_accessor :old_password
  
  def last_shipping_address
    last_cart = addresses.last
  end
  
  def self.scoped_search(address_hash, user_hash)
    address_sql_conditions = address_hash.collect{|a| "#{a[0]} LIKE '%#{a[1].downcase}%' OR #{a[0]} LIKE '%#{a[1].capitalize}%' OR #{a[0]} LIKE '%#{a[1]}%'" if a[1].present?}.compact.join(" OR ")
    user_sql_conditions = user_hash.collect{|a| "#{a[0]} LIKE '%#{a[1].downcase}%' OR #{a[0]} LIKE '%#{a[1].capitalize}%' OR #{a[0]} LIKE '%#{a[1]}%'" if a[1].present?}.compact.join(" OR ")
    
    users = Address.find(:all, :conditions => address_sql_conditions).map {|a| a.user}.compact unless address_hash.empty?
    users = users & find(:all, :conditions => user_sql_conditions).compact unless user_hash.empty?
    
    return users.present? ? users : []
  end
  
  # -- Customer financials --
    def total_orders
      orders.inject(0.0) {|total, order| total += safe_float(order.total)}
    end
    
    def total_spent
      orders.inject(0.0) {|total, order| total += safe_float(order.paid)}
    end
    
    def total_owing
      orders.inject(0.0) {|total, order| total += (safe_float(order.total) - safe_float(order.paid))}
    end
    
    def total_credit
      orders.map(&:payments).flatten.compact.inject(0.0) do |total, payment|
        payment.payment_type.name == "In Store Credit" ? total += payment.amount : total += 0.0
      end
    end
    
    def payments
      orders.collect {|order| order.payments}.flatten.compact
    end
  # --
  
  def current_order
    order = self.orders.website.open.first ? self.orders.website.open.first : self.orders << Order.create(:location => "website", :handed_off => false)
  end
  
  def password=(password)
    write_attribute(:password, User.hash_password(password))
  end
  
  def add_address(address)
    self.addresses << address unless self.address_ids.include? address.id
  end
  
  def safe_float(float)
    return 0.0 unless float
    return ("%.2f" % float).to_f
  end
  
  class << self
    def generate_plain_token
      words = %w{ cat shovel cloud find pass risk taco glass dog bottle can bowl spoon cheese chili fork cup fish chips }
      new_pass = "%s%s" % [ words[ rand( words.length ) ], words[ rand( words.length ) ] ]
      return new_pass
    end
    
    def generate_token
      return User.hash_password(User.generate_plain_token)
    end
    
    def hash_password(password)
      return Digest::SHA256.hexdigest(password)
    end
    
    def is_authentic(login, password)
      return User.find(:first, :conditions => ["login=? AND password=?", login, User.hash_password(password)]) || false
    end
  end
end
