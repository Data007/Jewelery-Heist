module CartsHelper
  def shipping_options_for_select(shipping_options)
    shipping_options.collect do |shipping_option|
      ["#{shipping_option[1][:name].titleize} #{number_to_currency(shipping_option[1][:price])}", shipping_option[1][:name]]
    end
  end
end
