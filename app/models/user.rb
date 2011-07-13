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
      return all unless user_query
      find_address = user_query.delete(:address) if (user_query[:address] && !user_query[:address].blank?)
      find_phone   = Regexp.new(user_query.delete(:phone)) if (user_query[:phone] && !user_query[:phone].blank?)
      find_email   = Regexp.new(user_query.delete(:email)) if (user_query[:email] && !user_query[:email].blank?)

      user_query.each { |(key, value)| user_query.delete(key.to_sym) if value.blank? }
      user_query = user_query.inject([]) { |hashes, (key, value)| hashes << {key.to_sym => Regexp.new(value)} }

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
  ##
end
