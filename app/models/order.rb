class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user
  embeds_many :line_items
  embeds_many :payments

  def add_payment(amount, payment_type='cash')
    payments.create amount: amount, payment_type: payment_type
  end

  def purchase
    update_attribute :purchased, true
  end

  def total
    line_items.map(&:total).sum
  end

  def payments_total
    payments.where(:amount.gt => 0).map(&:amount).sum
  end

  def credits_total
    -payments.where(payment_type: /credit/, :amount.lt => 0).map(&:amount).sum
  end

  def balance
    total - (payments_total + credits_total)
  end
end
