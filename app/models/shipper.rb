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

    def sample_destination
      Location.new( :country => 'CA',
                    :province => 'ON',
                    :city => 'Ottawa',
                    :postal_code => 'K1P 1J1')
    end
  end
end
