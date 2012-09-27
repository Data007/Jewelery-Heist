class CartsController < ApplicationController

  def update
    if @cart.update_attributes params[:cart]
      render text: 'ok'
    else
      render template: "carts/#{params[:current_step]}"
    end
  end

end
