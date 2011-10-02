class Color
  include Mongoid::Document
  include Mongoid::Timestamps

  field :position, type: Integer
  field :names

  default_scope asc(:position)

  embedded_in :variation
end
