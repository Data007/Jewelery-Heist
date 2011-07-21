class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :variations
end
