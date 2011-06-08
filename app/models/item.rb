class Item < ActiveRecord::Base
  extend ModelTools
  include AddZombies
  include AddZombies::ZombieState
  
  default_scope :order => "created_at DESC"
  
  # acts_as_audited
  
  index do
    name
    description
  end
  
  has_and_belongs_to_many :collections
  belongs_to :category
  belongs_to :gender
  belongs_to :designer
  
  # -- DISABLED FOR FUTURE VERSION
  # has_many :search_results
  # --
  
  has_many :line_items
  
  # -- 
    has_many :variations, :dependent => :destroy
    accepts_nested_attributes_for :variations, :allow_destroy => true
    
    scope :in_color, lambda { |color|
      {
        :joins      => :variations,
        :conditions => {:variations => {:id => color.variation_ids}},
        :select     => "DISTINCT items.*"
      }
    }
    def colors
      return Color.in_item(self)
    end
    
    scope :in_jewels, lambda { |jewel|
      {
        :joins      => :variations,
        :conditions => {:variations => {:id => color.variation_ids}},
        :select     => "DISTINCT items.*"
      }
    }
  # --
  
  scope :completed, :conditions => "name IS NOT NULL AND description IS NOT NULL"
  scope :not_completed, :conditions => "name IS NULL AND description IS NULL"
  
  scope :published, :conditions => {:published => true}
  scope :unpublished, :conditions => {:published => false}
  
  scope :ooak, :conditions => {:one_of_a_kind => true}
  scope :nooak, :conditions => {:one_of_a_kind => false}
  
  scope :available, :conditions => {:available => true}
  scope :not_available, :conditions => {:available => false}
  
  scope :listable, :conditions => {:available => true, :ghost => false}
  
  def empty_record?
    return (self.name == nil or self.description == nil) ? true : false
  end
  
  def first_image(image_type)
    return (self.variations.length > 0 && self.variations.first.assets.length > 0) ? self.variations.first.assets.by_position.first.image.url(image_type.to_s) : "/images/ui/no_image.jpg"
  end
  
  acts_as_url :name, :sync_url => true, :url_attribute => :slug
  
  def self.find_by_id_or_slug(query)
    begin
      found = self.find(query)
    rescue
      found = self.find_by_slug(query)
    end
    return found
  end
  
  def collections_csv
    self.collections.collect {|collection| collection.id }.join(",")
  end
  
  def collections_csv=(csv)
    new_collections = []
    self.class.unique_from_csv(csv).each do |collection_id|
      new_collections << Collection.find(collection_id)
    end
    self.collections = new_collections
  end
  
  def sizes
    available_sizes = []
    unless self.size_range.empty?
      if self.size_range.match(/,/)
        self.size_range.split(",").each do |size_token|
          if size_token.match(/-/)
            begin_range_at, end_range_at = size_token.split("-")
            (begin_range_at.to_i..end_range_at.to_i).each do |size|
              available_sizes << size
              available_sizes << "#{size}.5".to_f
            end
          else
            available_sizes << size_token.to_f
          end
        end
      elsif self.size_range.match(/-/)
        begin_range_at, end_range_at = self.size_range.split("-")
        (begin_range_at.to_i..end_range_at.to_i).each do |size|
          available_sizes << size
          available_sizes << "#{size}.5".to_f
        end
      else
        available_sizes << self.size_range.to_f
      end
    end
    return available_sizes
  end
  
  def to_param
    if self.name != nil
      return "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
    else
      return id.to_s
    end
  end
  
  def destroy
    super
    self.variations.each {|v| v.update_attributes :quantity => 0}
    self.update_attributes :published => false, :available => false
    self.save
  end
end
