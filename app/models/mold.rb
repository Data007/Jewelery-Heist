class Mold < ActiveRecord::Base
  # acts_as_audited
  include AddZombies
  include AddZombies::ZombieState
  
  has_many :assets, :as => :attachable, :dependent => :destroy
  has_and_belongs_to_many :variations
  accepts_nested_attributes_for :assets, :allow_destroy => true
end
