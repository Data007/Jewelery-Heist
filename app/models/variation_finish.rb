class VariationFinish < ActiveRecord::Base
  extend ModelTools
  include InstanceModules
  
  # acts_as_audited
  
  index do
    name
  end
  
  belongs_to :variation
  
  named_scope :unique, :select => "DISTINCT name, id, variation_id"
  named_scope :like, (lambda {|search_term| {
    :select => "DISTINCT name, id",
    :conditions => ["name LIKE ?", "%#{search_term}%"]
  }})
end
