require 'digest/sha2'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :emails,       type: Array,   default: []
  field :phones,       type: Array,   default: []
  field :login
  field :password_hash
  field :is_active,    type: Boolean, default: false
  field :role,         default: 'public'
  field :name

  embeds_many :addresses

  attr_accessor :password, :password_confirmation

  validates :name, presence: true, on: :create

  before_save :generate_password_hash

  # Scopes
  class << self
    
    def full_search(user_query)
      address = user_query.delete(:address)
      phone   = user_query.delete(:phone)
      email   = user_query.delete(:email)

      user_query.each { |(key, value)| user_query.delete(key.to_sym) if value.blank? }
      user_query = user_query.inject([]) { |hashes, (key, value)| hashes << {key.to_sym => value} }
      
      any_of(*user_query)
    end

  end
  ##
  
  # Authentication
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

  class << self

    def hash_password(password)
      Digest::SHA256.hexdigest password
    end

    def authorize(login, password)
      user = first(conditions: {login: login, password_hash: hash_password(password)})
      (user && user.is_active) ? user : nil
    end

  end
  ##

  # Financial
  def total_spent
    0
  end

  def total_credit
    0
  end

  def total_owing
    0
  end
  #
end
