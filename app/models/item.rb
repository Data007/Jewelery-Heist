class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  embeds_many :variations

  class << self

    def search(query)
      where(name: Regexp.new(query))
    end

  end
end
