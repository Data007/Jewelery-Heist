class Asset
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :variation
end
