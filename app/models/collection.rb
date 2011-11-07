class Collection
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :name
  field :description
  field :custom_id

  field :pretty_id,    type: Integer
  sequence :pretty_id  

  has_and_belongs_to_many :items

  default_scope asc(:pretty_id)
end
