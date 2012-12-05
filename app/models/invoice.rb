class Invoice
  include Mongoid::Document

  embedded_in :order
  embeds_many :payments

  def add_payment(details)
    payment = self.payments.create(details)
    save
    # TODO: get a balance with the real shipping cost added in
    if order.balance == 0.0
      order.update_attribute :purchased, true
    end

    return payment
  end
end
