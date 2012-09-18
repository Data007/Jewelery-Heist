# NOTE: make a rake task to migrate old array phones to the model phone

class Phone
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :number

  embedded_in :user
end

