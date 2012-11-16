class CartsController < ApplicationController
  def checkout
    @cart.update_attribute(:current_stage, 'checkout') unless @cart.current_stage 
  end

  def pay
    @cart.credit_card     = CreditCard.new unless @cart.credit_card
    @cart.billing_address = @cart.shipping_address
  end
  
  def summary
    binding.pry
  end

  def process_cart
    if @cart.process_cart
      redirect_to [:summary]
    else
      render template: [:pay]
    end
  end 

  def update
    if @cart.update_attributes params[:cart]
      redirect_to @cart.current_stage.to_sym
    else
      render template: "carts/#{params[:current_stage]}"
    end
  end
end
