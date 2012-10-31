desc 'Taking open orders and moving them over to carts'
task order_to_cart: :environment do
  binding.pry
  Order.where(purchased: false). each do |order|
    user = order.user
    
    user.cart = Cart.new unless user.cart

  end  
end

