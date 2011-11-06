class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :name
  field :description
  field :ghost,         type: Boolean, default: false
  field :one_of_a_kind, type: Boolean, default: false
  field :customizable,  type: Boolean, default: false
  field :available,     type: Boolean, default: true
  field :published,     type: Boolean, default: false
  field :discontinued,  type: Boolean, default: false
  field :cost,          type: Float
  field :designer_id
  field :size_range
  field :category
  field :gender
  field :custom_id
  field :customizable_notes
  field :discontinued_notes

  field :pretty_id,    type: Integer
  sequence :pretty_id  

  embeds_many :variations
  has_and_belongs_to_many :collections

  validates :name, presence: true

  after_save :create_variation

  def create_variation
    return true if variations.present?
    variations.create
    save
  end

  CATEGORIES = [
    ['Ring', 'ring'],
    ['Necklace', 'necklace'],
    ['Earrings', 'earrings'],
    ['Bracelet', 'bracelet'],
    ['Everything Else', 'everthing else']
  ]

  GENDERS = [
    ['Mens', 'mens'],
    ['Womens', 'womans'],
    ['Unisex', 'unisex']
  ]

  scope :published,     where(published: true)
  scope :unpublished,   where(published: false)
  scope :available,     where(available: true)
  scope :not_available, where(available: false)
  scope :listable,      where(available: true, ghost: false)
  scope :ooak,          where(one_of_a_kind: true)
  scope :nooak,         where(one_of_a_kind: false)

  scope :with_color_id, ->(color_id) {
    where('variations.colors._id' => color_id)
  }

  scope :with_color,    ->(color_name) {
    where('variations.colors.names' => Regexp.new(color_name))
  }

  class << self
  
    def find_variation(variation_id)
      where('variations._id' => variation_id).
      map do|item| 
        item.variations.find(variation_id)
      end.flatten.first
    end

    def search(query)
      where(name: Regexp.new(query))
    end

    def categories
      CATEGORIES
    end

    def genders
      GENDERS
    end

    def colors
      where(:'variations.colors.names'.exists => true).
      map(&:variations).flatten.
      map(&:colors).flatten.uniq
    end

    def colors_with(color_name)
      colors.
      select do |color|
        color.names =~ Regexp.new(color_name)
      end.flatten.uniq {|color| color.names }
    end

    def colors_from_position(position)
      colors.
      select do |color|
        color.position == position
      end.flatten.uniq
    end

  end

  def designer
    designer_id ? User.find(designer_id) : nil
  end

  def designer=(user)
    self.designer_id = user.id
  end

  def sizes
    available_sizes = []
    if size_range =~ /,/
      available_sizes += split_sizes(size_range)
    elsif size_range =~ /-/
      available_sizes += split_size_range(size_range) # returns an array of size strings
    else
      available_sizes = [size_range]
    end
    return available_sizes.flatten
  end

  def sizes=(new_size_range)
    self.size_range = new_size_range
  end

  def collections_csv=(csv)
    new_collections = []
    csv.split(',').each do |collection_id|
      new_collections << Collection.find(collection_id) unless new_collections.include?(Collection.find(collection_id))
    end
    self.collections = new_collections
  end

  def collections_csv
    self.collections.collect {|collection| collection.id }.join(",")
  end
  
    

private

  def split_size_range(range)
    return range unless range =~ /-/
    sizes_from_range = []
    start_range, end_range = range.split('-')

    (start_range.to_i..end_range.to_i).each do |size|
      sizes_from_range.push(size.to_s)
      sizes_from_range.push("#{size}.5") unless size == end_range.to_i
    end

    return sizes_from_range
  end

  def split_sizes(sizes_csv)
    return sizes_csv.split(/,/).map {|range| split_size_range(range)}.flatten
  end
    
end
