class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :ghost,       type: Boolean, default: false
  field :available,   type: Boolean, default: true
  field :designer_id, type: Integer
  field :size_range

  embeds_many :variations

  class << self

    def search(query)
      where(name: Regexp.new(query))
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
    end
    return available_sizes.flatten
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
