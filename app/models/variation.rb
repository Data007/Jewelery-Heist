class Variation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description
  field :price,         type: Float,   default: 0.0
  field :quantity,      type: Integer, default: 1
  field :parent_item_id

  embedded_in :item
  embeds_many :assets

  before_save :set_parent_item_id

  def parent_item
    Item.find(parent_item_id)
  end

private

  def set_parent_item_id
    self.parent_item_id = item.id unless parent_item_id
  end
end
