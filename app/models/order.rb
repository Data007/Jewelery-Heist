class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user
  embeds_many :line_items

  def purchase
    update_attribute :purchased, true
  end

  def total
    line_items.map(&:total).sum
  end
end
