require 'digest/sha2'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :emails, type: Array, default: []
  field :phones, type: Array, default: []
  field :login
  field :password_hash
  field :name

  embeds_many :addresses

  attr_accessor :password, :password_confirmation

  validates :name, presence: true, on: :create

  before_save :generate_password_hash
  
  def generate_password_hash
    if (password.present? && password_confirmation.present?)
      if password == password_confirmation
        self.password_hash = self.class.send(:hash_password, password)
      else
        errors.add :password_confirmation, 'does not match the password'
      end
    end
  end

  class << self

    def hash_password(password)
      Digest::SHA256.hexdigest password
    end

  end
end
