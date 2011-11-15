class Variation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  include MafiaConnections

  field :description
  field :price,          type: Float,   default: 0.0
  field :quantity,       type: Integer, default: 1
  field :parent_item_id
  field :custom_id
  field :metals,         type: Array
  field :finishes,       type: Array
  field :jewels,         type: Array
  field :colors,         type: Array # TODO: Make it work!
  field :backorder_notes

  field :pretty_id,    type: Integer
  sequence :pretty_id  

  embedded_in :item
  embeds_many :assets

  before_save :set_parent_item_id
  before_save :validate_price

  def validate_price
    self.price = launder_money(self.price)
  end

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

    def find_by_custom_id(query_id)
      query = Item.where(:'variations.custom_id' => query_id)
      return nil if query.empty?
      query.first.variations.where(custom_id: query_id).first
    end

  end

  def parent_item
    Item.find(parent_item_id)
  end

  def colors_csv
    colors.map(&:position).join(',')
  end

  def colors_csv=(csv)
    self.colors = csv.split(',').sort.map {|position| Item.colors_from_position(position).first}.compact
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

  def update_asset_position(asset, position=nil)
    new_position = position.nil? ? self.assets.length : position.to_i

    asset_list   = self.assets
    sort_asset   = asset_list.delete(asset)
    asset_list.insert new_position, sort_asset
    asset_list.compact!

    asset_list.each_with_index {|saved_asset, index| saved_asset.update_attribute :position, index}
    assets       = asset_list
    save
  end

private

  def set_parent_item_id
    self.parent_item_id = item.id unless parent_item_id
  end
end
