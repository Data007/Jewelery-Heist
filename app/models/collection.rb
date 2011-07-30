class Collection
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description
  field :custom_id

  has_and_belongs_to_many :items

  default_scope asc(:custom_id)
end
