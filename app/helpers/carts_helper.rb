module CartsHelper
  def shipping_options_for_select(shipping_options)
    shipping_options.collect do |shipping_option|
      ["#{shipping_option[:name].titleize} #{number_to_currency(shipping_option[:total_net_charge])}", shipping_option[:name]]
    end
  end
end
