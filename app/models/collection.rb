class Collection < ActiveRecord::Base
  include AddZombies
  include AddZombies::ZombieState
  
  # acts_as_audited
  
  has_and_belongs_to_many :items
  
  default_scope :order => "id asc"
  
  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  # -- DISABLED FOR FUTURE VERSION
  # has_attached_file :image,
  #   :styles => {
  #     :splash     => "640x480",
  #     :thumbnail  => "100x120"
  #   },
  #   :path => ":rails_root/public/images/assets/Collection/:attachment/:id/:basename-:style.:extension",
  #   :url => "/images/assets/Collection/:attachment/:id/:basename-:style.:extension"
  # 
  # attr_accessor :metals, :jewels, :finishes, :colors, :genders, :categories, :searches, :possible_results
  # 
  # has_many :search_results, :table_name => "collection_search_results"
  # 
  # def after_initialize
  #   # -- initialize the search accessors as empty arrays
  #   %w(metals jewels finishes colors genders categories searches possible_results).each do |search_type|
  #     instance_eval("@#{search_type} ||= []")
  #   end
  #   
  #   # -- fill the search accessors with parsed values from search_string
  #   init_search_elements unless self.search_string == nil
  #   
  #   # -- find the first search results
  #   item_search_term = build_query(@genders + @categories + @searches)
  #   if item_search_term.length > 0
  #     Item.find_with_index(item_search_term).each {|item| @possible_results << item}
  #   end
  # end
  # 
  # def build_query(terms)
  #   search_term = terms.join(" AND ")
  #   return search_term
  # end
  # 
  # def init_search_elements
  #   elements = self.search_string.split(" ")
  #   elements.each do |element|
  #     search_type, search_term = element.split(":")
  #     if search_term
  #       search_elements = instance_eval("@#{search_type.pluralize}")
  #       search_elements << search_term
  #     else
  #       @searches << search_type
  #     end
  #   end
  #   return nil
  # end
  # -- DISABLED FOR FUTURE VERSION
end
