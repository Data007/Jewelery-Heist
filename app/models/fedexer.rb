class Fedexer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  SHIPPING_OPTIONS = ['FEDEX_EXPRESS_SAVER', 'FEDEX_GROUND', 'FEDEX_2_DAY','STANDARD_OVERNIGHT']
  INTERNATIONAL_SHIPPING_OPTIONS = ['INTERNATIONAL_ECONOMY', 'INTERNATIONAL_PRIORITY']

  class << self
    def sample_package
      [{
        weight: {units: 'LB', value: 2},
        dimensions: {length: 10, width: 5, height: 4, units: 'IN'}
      }]
    end

    def default_shipping_details
      {
        packaging_type: 'YOUR_PACKAGING',
        drop_off_type: 'REGULAR_PICKUP'
      }
    end

    def shipping_details type
      {
        
      }
    end

    def load_keys
      provider_keys = YAML.load_file(File.join(Rails.root, 'config', 'fedex_keys.yml'))[Rails.env]
      provider_keys.inject({}) do |new_hash, (key, value)|
        new_hash[key.to_sym] = value
        new_hash
      end
    end

    def get_rate shipment, recipient, packages, shipment_type, shipping_details
      shipment.rate(
        shipper: self.shipper,
        recipient: recipient,
        packages: packages,
        service_type: shipment_type,
        shipping_details: shipping_details
      )
    end

    def shipment
      Fedex::Shipment.new(Fedexer.load_keys)
    end

    def shipper
      {
        name: 'Wexford Jewlers',
        phone_number: '2317751289',
        address: '801 North Mitchell Street',
        city: 'Cadillac',
        state: 'MI',
        postal_code: '49601',
        country_code: 'US' 
      }
    end

    def recipient name, address, phone_number
      {
        name: name,
        phone_number: phone_number,
        address: address.address_1,
        city: address.city,
        state: address.province,
        postal_code: address.postal_code,
        country_code: address.country,
        residential: 'false'
      }
    end

    def create_packages packages
    end
  end
end
