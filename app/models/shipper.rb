include ActiveMerchant::Shipping

class Shipper
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence


  SHIPPING_COUNTRIES = [["United States", "US"], ["Canada", "CA"],["Afghanistan", "AF"], ["Albania", "AL"], ["Algeria", "DZ"], ["American Samoa", "AS"], ["Andorra", "AD"], ["Angola", "AO"], ["Anguilla", "AI"], ["Antigua", "AG"], ["Argentina", "AR"], ["Armenia", "AM"], ["Aruba", "AW"], ["Australia", "AU"], ["Austria", "AT"], ["Azerbaijan", "AZ"], ["Bahamas", "BS"], ["Bahrain", "BH"], ["Bangladesh", "BD"], ["Barbados", "BB"], ["Barbuda", "AG"], ["Belarus", "BY"], ["Belgium", "BE"], ["Belize", "BZ"], ["Benin", "BJ"], ["Bermuda", "BM"], ["Bhutan", "BT"], ["Bolivia", "BO"], ["Bonaire", "AN"], ["Bosnia", "BA"], ["Botswana", "BW"], ["Brazil", "BR"], ["British Guyana", "GY"], ["British Virgin Islands", "VG"], ["Brunei", "BN"], ["Bulgaria", "BG"], ["Burkina Faso", "BF"], ["Burundi", "BI"], ["Cambodia", "KH"], ["Cameroon", "CM"], ["Canary Islands", "ES"], ["Cape Verde", "CV"], ["Cayman Islands", "KY"], ["Chad", "TD"], ["Channel Islands", "GB"], ["Chile", "CL"], ["China, PeopleS Republic Of", "CN"], ["Colombia", "CO"], ["Congo", "CG"], ["Congo, Dem Rep Of", "CD"], ["Cook Islands", "CK"], ["Costa Rica", "CR"], ["Croatia", "HR"], ["Curacao", "AN"], ["Cyprus", "CY"], ["Czech Republic", "CZ"], ["Denmark", "DK"], ["Djibouti", "DJ"], ["Dominica", "DM"], ["Dominican Republic", "DO"], ["Ecuador", "EC"], ["Egypt", "EG"], ["El Salvador", "SV"], ["England (United Kingdom)", "GB"], ["Eritrea", "ER"], ["Estonia", "EE"], ["Ethiopia", "ET"], ["Faeroe Islands", "FO"], ["Fiji", "FJ"], ["Finland", "FI"], ["France", "FR"], ["French Guiana", "GF"], ["French Polynesia", "PF"], ["Gabon", "GA"], ["Gambia", "GM"], ["Georgia, Republic Of", "GE"], ["Germany", "DE"], ["Ghana", "GH"], ["Gibraltar", "GI"], ["Grand Cayman", "KY"], ["Great Britain", "GB"], ["Great Thatch Island", "VG"], ["Great Tobago Island", "VG"], ["Greece", "GR"], ["Greenland", "GL"], ["Grenada", "GD"], ["Guadeloupe", "GP"], ["Guam", "GU"], ["Guatemala", "GT"], ["Guinea", "GN"], ["Guyana", "GY"], ["Guyane", "GF"], ["Haiti", "HT"], ["Holland", "NL"], ["Honduras", "HN"], ["Hong Kong", "HK"], ["Hungary", "HU"], ["Iceland", "IS"], ["India", "IN"], ["Indonesia", "ID"], ["Iraq", "IQ"], ["Ireland, Northern", "GB"], ["Ireland, Republic Of", "IE"], ["Israel", "IL"], ["Italy", "IT"], ["Ivory Coast", "CI"], ["Jamaica", "JM"], ["Japan", "JP"], ["Jordan", "JO"], ["Jost Van Dyke Island", "VG"], ["Kazakhstan", "KZ"], ["Kenya", "KE"], ["Korea, South (South Korea)", "KR"], ["Kuwait", "KW"], ["Kyrgyzstan", "KG"], ["Laos", "LA"], ["Latvia", "LV"], ["Lebanon", "LB"], ["Lesotho", "LS"], ["Liberia", "LR"], ["Libya", "LY"], ["Liechtenstein", "LI"], ["Lithuania", "LT"], ["Luxembourg", "LU"], ["Macau", "MO"], ["Macedonia", "MK"], ["Madagascar", "MG"], ["Malawi", "MW"], ["Malaysia", "MY"], ["Maldives, Republic Of", "MV"], ["Mali", "ML"], ["Malta", "MT"], ["Marshall Islands", "MH"], ["Martinique", "MQ"], ["Mauritania", "MR"], ["Mauritius", "MU"], ["Mexico", "MX"], ["Micronesia", "FM"], ["Moldova", "MD"], ["Monaco", "MC"], ["Mongolia", "MN"], ["Montenegro", "ME"], ["Montserrat", "MS"], ["Morocco", "MA"], ["Mozambique", "MZ"], ["Namibia", "NA"], ["Nepal", "NP"], ["Netherlands (Holland)", "NL"], ["Netherlands Antilles (Caribbean)", "AN"], ["Nevis", "KN"], ["New Caledonia", "NC"], ["New Guinea", "PG"], ["New Zealand", "NZ"], ["Nicaragua", "NI"], ["Niger", "NE"], ["Nigeria", "NG"], ["Norfolk Island", "AU"], ["Norman Island", "VG"], ["Norway", "NO"], ["Oman", "OM"], ["Pakistan", "PK"], ["Palau", "PW"], ["Panama", "PA"], ["Papua New Guinea", "PG"], ["Paraguay", "PY"], ["Peru", "PE"], ["Philippines", "PH"], ["Poland", "PL"], ["Portugal", "PT"], ["Puerto Rico", "US"], ["Qatar", "QA"], ["Reunion", "RE"], ["Romania", "RO"], ["Rota", "MP"], ["Russia", "RU"], ["Rwanda", "RW"], ["Saba", "AN"], ["Saipan", "MP"], ["San Marino", "IT"], ["Saudi Arabia", "SA"], ["Scotland", "GB"], ["Senegal", "SN"], ["Serbia", "RS"], ["Seychelles", "SC"], ["Singapore", "SG"], ["Slovak Republic", "SK"], ["Slovenia", "SI"], ["South Africa, Republic Of", "ZA"], ["Spain", "ES"], ["Sri Lanka", "LK"], ["St. Barthelemy", "GP"], ["St. Christopher", "KN"], ["St. Croix Island", "VI"], ["St. Eustatius", "AN"], ["St. John", "VI"], ["St. Kitts And Nevis", "KN"], ["St. Lucia", "LC"], ["St. Maarten", "AN"], ["St. Martin", "AN"], ["St. Thomas", "VI"], ["St. Vincent", "VC"], ["Suriname", "SR"], ["Swaziland", "SZ"], ["Sweden", "SE"], ["Switzerland", "CH"], ["Syria", "SY"], ["Tahiti", "PF"], ["Taiwan, Republic Of China", "TW"], ["Tanzania", "TZ"], ["Thailand", "TH"], ["Tinian", "MP"], ["Togo", "TG"], ["Tortola Island", "VG"], ["Trinidad And Tobago", "TT"], ["Tunisia", "TN"], ["Turkey", "TR"], ["Turks And Caicos Islands", "TC"], ["US Virgin Islands", "VI"], ["Uganda", "UG"], ["Ukraine", "UA"], ["Union Island", "VC"], ["United Arab Emirates", "AE"], ["United Kingdom", "GB"], ["United States", "US"], ["Uruguay", "UY"], ["Uzbekistan", "UZ"], ["Vanuatu", "VU"], ["Vatican City", "IT"], ["Venezuela", "VE"], ["Vietnam", "VN"], ["Wales (United Kingdom)", "GB"], ["Wallis & Futuna Islands", "WF"], ["Yemen, The Republic Of", "YE"], ["Zambia", "ZM"], ["Zimbabwe", "ZW"]]
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

    #redo
    def get_ups_rate destination_address, packages
      ups = UPS.new(test_mode: true, :login => 'wexfordjewelers', :password => 'CROUP59\iota', :key => 'FCA9039C9A358F68')
      response = ups.find_rates(wexford_jewelers_address, destination(destination_address), sample_packages)
      ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    end
  
    #redo
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

    def rates address, packages
      rates = {}

      ups = UPS.new(test_mode: true, :login => 'wexfordjewelers', :password => 'CROUP59\iota', :key => 'FCA9039C9A358F68')
      ups_response = ups.find_rates(wexford_jewelers_address, destination(address), sample_packages)
      ups_response.rates.sort_by(&:price).each {|rate| rates["UPS-#{rate.service_code}".to_sym] = {name: rate.service_name, price: (rate.price.to_f)/100}}
      
      fedex = FedEx.new(key: 'wikjDtsCxIh2iohD', password: 'Cw10xEFUV6f0kmz861HJdf8NQ', account: '510087925', login: '118569532', test: true)
      fedex_response = fedex.find_rates(Shipper.wexford_jewelers_address, Shipper.sample_destination, Shipper.sample_packages)
      fedex_response.rates.sort_by(&:price).each {|rate| rates["FEDEX-#{rate.service_code}".to_sym] = {name: rate.service_name, price: (rate.price.to_f)/100}}

      rates
    end
  end
end
