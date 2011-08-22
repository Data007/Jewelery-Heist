class Variation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description
  field :price,         type: Float,   default: 0.0
  field :quantity,      type: Integer, default: 1
  field :parent_item_id
  field :custom_id
  field :metals,        type: Array
  field :finishes,      type: Array
  field :jewels,        type: Array

  embedded_in :item
  embeds_many :assets

  has_and_belongs_to_many :colors

  before_save :set_parent_item_id

  class << self
    
    def jewels_like(query)
      Item.any_in(:'variations.jewels' => [Regexp.new(query)]).map {|item|
        item.variations.map(&:jewels)
      }.flatten.compact.uniq.select {|jewel| jewel.match(Regexp.new(query))}
    end

    def metals_like(query)
      Item.any_in(:'variations.metals' => [Regexp.new(query)]).map {|item|
        item.variations.map(&:metals)
      }.flatten.compact.uniq.select {|metal| metal.match(Regexp.new(query))}
    end

    def finishes_like(query)
      Item.any_in(:'variations.finishes' => [Regexp.new(query)]).map {|item|
        item.variations.map(&:finishes)
      }.flatten.compact.uniq.select {|finish| finish.match(Regexp.new(query))}
    end

  end

  def parent_item
    Item.find(parent_item_id)
  end

  def colors_csv
    colors.map(&:position).join(',')
  end

  def colors_csv=(csv)
    self.colors = csv.split(',').sort.map {|position| Color.where(position: position).first}
  end

  def metal_csv
    return '' unless metals
    metals.join(',')
  end

  def metal_csv=(csv)
    self.metals = csv.split(',')
  end

  def finish_csv
    return '' unless finishes
    finishes.join(',')
  end

  def finish_csv=(csv)
    self.finishes = csv.split(',')
  end

  def jewel_csv
    return '' unless jewels
    jewels.join(',')
  end

  def jewel_csv=(csv)
    self.jewels = csv.split(',')
  end

  def update_asset_position(asset, position)
    asset_list = (assets - [asset]).flatten.compact
    asset_list.insert(position, asset)
    asset_list.compact!
    asset_list.each_with_index {|asset, index| asset.update_attribute :position, index}
    assets = asset_list
    save
  end

private

  def set_parent_item_id
    self.parent_item_id = item.id unless parent_item_id
  end
end
