class Faq
  include Mongoid::Document

  field :header
  field :body
  field :custom_id
end
