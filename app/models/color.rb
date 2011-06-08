class Color < ActiveRecord::Base
  # acts_as_audited
  
  has_and_belongs_to_many :variations
  
  named_scope :sorted_by_position, :order => "position ASC"
  named_scope :in_item, lambda { |item|
    {
      :joins      => :variations,
      :conditions => {:variations => {:id => item.variation_ids}},
      :select     => "DISTINCT colors.*"
    }
  }
  
  def items
    return Item.in_color(self)
  end
  
  def to_param
    if self.names != nil
      return "#{id}-#{names.gsub(/[^a-z0-9]+/i, '-')}"
    else
      return id.to_s
    end
  end
end
