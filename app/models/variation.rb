module VariationErrors
  class EmptyItemId < StandardError; end
end

class Variation < ActiveRecord::Base
  include VariationErrors
  
  extend ModelTools
  include AddZombies
  include AddZombies::ZombieState
  
  default_scope :conditions => {:ghost => false}, :order => "created_at DESC"
  
  # acts_as_audited
  acts_as_indexed :fields => [:description], :min_word_size => 3, :index_file => [RAILS_ROOT,"tmp","index"]
  
  # -- Shopping Related --
    has_many :line_items
    has_many :orders, :through => :line_items
    has_many :tickets, :through => :orders
  # --
  
  belongs_to :item
  has_many :search_results
  has_many :assets, :as => :attachable, :dependent => :destroy
  has_one :metal, :class_name => "VariationMetal", :dependent => :destroy
  has_one :jewel, :class_name => "VariationGem", :dependent => :destroy
  has_one :finish, :class_name => "VariationFinish", :dependent => :destroy
  has_and_belongs_to_many :molds
  has_and_belongs_to_many :colors
  
  accepts_nested_attributes_for :assets, :allow_destroy => true
  accepts_nested_attributes_for :metal, :allow_destroy => true
  accepts_nested_attributes_for :finish, :allow_destroy => true
  accepts_nested_attributes_for :jewel, :allow_destroy => true
  accepts_nested_attributes_for :line_items
  
  before_create :validate_item_id

  def validate_item_id
    raise EmptyItemId, "You need an item in order to have a variation. We cannot find an item that this ties to." if self.item_id == nil
  end
  
  def empty_record?
    return (self.item && self.item.variations.length < 2) ? true : false
  end
  
  def metals
    return self.metal != nil ? self.metal.name.split(",") : []
  end
  
  def finishes
    return self.finish != nil ? self.finish.name.split(",") : []
  end
  
  def jewels
    return self.jewel != nil ? self.jewel.name.split(",") : []
  end
  
  def molds_csv
    self.molds.collect {|mold| mold.id }.join(",")
  end
  
  def molds_csv=(csv)
    new_molds = []
    self.class.unique_from_csv(csv).each do |mold_id|
      begin
        mold = (Mold.find_by_custom_id("#{mold_id}") or Mold.find("#{mold_id}"))
      rescue
        mold = Mold.create({:custom_id => mold_id})
      end
      new_molds << mold
    end
    self.molds = new_molds
  end
  
  def colors_csv
    self.colors.collect {|color| color.position }.join(",")
  end
  
  def colors_csv=(csv)
    new_colors = []
    self.class.unique_from_csv(csv).each do |color_position|
      new_colors << Color.find_by_position(color_position)
    end
    self.colors = new_colors
  end
  
  def first_image_url(image_type)
    image_url = ""
    self.assets.each do |asset|
      image_url = asset.image.url(:"#{image_type}") if asset.image_file_name != nil
    end
    return image_url
  end
end
