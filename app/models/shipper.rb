include ActiveMerchant::Shipping
class Shipper
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  class << self
    def sample_packages
      [
        Package.new(  100,    
                      [93,10],
                      :cylinder => true),

        Package.new(  (7.5 * 16),
                      [15, 10, 4.5],
                      :units => :imperial)
      ]
    end

    def sample_origin
      Location.new( :country => 'US',
                    :state => 'CA',
                    :city => 'Beverly Hills',
                    :zip => '90210')
    end

    def sample_international_destination
      Location.new( :country => 'CA',
                    :province => 'ON',
                    :city => 'Ottawa',
                    :postal_code => 'K1P 1J1')
    end

    def sample_destination
      Location.new(
        country:  'US',
        state:    'MI',
        city:     'Cadillac',
        zip:      '49601'
      )
    end

    def destination address
      Location.new(
        country:  "#{address.country}",
        state:    "#{address.province}",
        city:     "#{address.city}",
        zip:      "#{address.postal_code}"
      )
    end

    def get_ups_rate destination_address, packages
      ups = UPS.new(test_mode: true, :login => 'wexfordjewelers', :password => 'CROUP59\iota', :key => 'FCA9039C9A358F68')
      response = ups.find_rates(wexford_jewelers_address, destination(destination_address), sample_packages)
      ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    end

    def order_rate order
      begin
        rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(order.cart.full_name, order.address, '2319203456' ), Fedexer.sample_packages, order.shipping_option, Fedexer.default_shipping_details)
      rescue
        rate = individual_ups_rate(order.address, order.shipping_option) 
      end
    end

    def individual_ups_rate shipping_address, shipping_type
      ups_rates = get_ups_rate(shipping_address, sample_packages)

      ups_rates.each do |rate|
        if rate[0].upcase == shipping_type.upcase
          return rate[1]
        end
      end
    end

    def wexford_jewelers_address
      Location.new(
        country:  'US',
        state:    'MI',
        city:     'Cadillac',
        zip:      '49601'
      )
    end
  end
end
