class Invoice
  include Mongoid::Document

  embedded_in :order
  embeds_many :payments
end
