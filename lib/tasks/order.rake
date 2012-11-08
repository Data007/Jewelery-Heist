desc 'Taking open orders and moving them over to carts'
task order_to_cart: :environment do
  User.all.each do |user|
    user.orders.where(purchased: false, location: 'website', staging_type: 'purchase').each do |order|
    
      user.cart = Cart.new 
      cart = user.cart
      cart.first_name = user.first_name unless user.first_name.nil?
      cart.last_name = user.last_name unless user.last_name.nil?
      cart.email = user.email unless user.email.nil?
      cart.phone = user.phones.first.number unless user.phones == []
      cart.current_stage = 'checkout'
      cart.shipping_address = order.address
      cart.line_items += order.line_items
      cart.payment = order.payments.first
    
      user.cart.save
      user.save
    end
    # grab the order details from the newset web order
    # transfer them to a new user cart
    # see how we merged carts in app/controllers/application_controller.rb
    # save cart and user
  end
end

