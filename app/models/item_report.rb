class ItemReport < Item
  class << self
    def current_stock
      available.the_living.collect do |item|
        item.variations.the_living.collect do |variation|
          variation if variation.quantity >= 1
        end
      end.flatten.compact
    end
  end
end