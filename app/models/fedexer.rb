class Fedexer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  SHIPPING_OPTIONS = ['FEDEX_EXPRESS_SAVER', 'FEDEX_GROUND', 'FEDEX_2_DAY','STANDARD_OVERNIGHT']
  INTERNATIONAL_SHIPPING_OPTIONS = ['INTERNATIONAL_ECONOMY', 'INTERNATIONAL_PRIORITY']

  SHIPPING_COUNTRIES = [["United States", "US"], ["Canada", "CA"],["Afghanistan", "AF"], ["Albania", "AL"], ["Algeria", "DZ"], ["American Samoa", "AS"], ["Andorra", "AD"], ["Angola", "AO"], ["Anguilla", "AI"], ["Antigua", "AG"], ["Argentina", "AR"], ["Armenia", "AM"], ["Aruba", "AW"], ["Australia", "AU"], ["Austria", "AT"], ["Azerbaijan", "AZ"], ["Bahamas", "BS"], ["Bahrain", "BH"], ["Bangladesh", "BD"], ["Barbados", "BB"], ["Barbuda", "AG"], ["Belarus", "BY"], ["Belgium", "BE"], ["Belize", "BZ"], ["Benin", "BJ"], ["Bermuda", "BM"], ["Bhutan", "BT"], ["Bolivia", "BO"], ["Bonaire", "AN"], ["Bosnia", "BA"], ["Botswana", "BW"], ["Brazil", "BR"], ["British Guyana", "GY"], ["British Virgin Islands", "VG"], ["Brunei", "BN"], ["Bulgaria", "BG"], ["Burkina Faso", "BF"], ["Burundi", "BI"], ["Cambodia", "KH"], ["Cameroon", "CM"], ["Canary Islands", "ES"], ["Cape Verde", "CV"], ["Cayman Islands", "KY"], ["Chad", "TD"], ["Channel Islands", "GB"], ["Chile", "CL"], ["China, PeopleS Republic Of", "CN"], ["Colombia", "CO"], ["Congo", "CG"], ["Congo, Dem Rep Of", "CD"], ["Cook Islands", "CK"], ["Costa Rica", "CR"], ["Croatia", "HR"], ["Curacao", "AN"], ["Cyprus", "CY"], ["Czech Republic", "CZ"], ["Denmark", "DK"], ["Djibouti", "DJ"], ["Dominica", "DM"], ["Dominican Republic", "DO"], ["Ecuador", "EC"], ["Egypt", "EG"], ["El Salvador", "SV"], ["England (United Kingdom)", "GB"], ["Eritrea", "ER"], ["Estonia", "EE"], ["Ethiopia", "ET"], ["Faeroe Islands", "FO"], ["Fiji", "FJ"], ["Finland", "FI"], ["France", "FR"], ["French Guiana", "GF"], ["French Polynesia", "PF"], ["Gabon", "GA"], ["Gambia", "GM"], ["Georgia, Republic Of", "GE"], ["Germany", "DE"], ["Ghana", "GH"], ["Gibraltar", "GI"], ["Grand Cayman", "KY"], ["Great Britain", "GB"], ["Great Thatch Island", "VG"], ["Great Tobago Island", "VG"], ["Greece", "GR"], ["Greenland", "GL"], ["Grenada", "GD"], ["Guadeloupe", "GP"], ["Guam", "GU"], ["Guatemala", "GT"], ["Guinea", "GN"], ["Guyana", "GY"], ["Guyane", "GF"], ["Haiti", "HT"], ["Holland", "NL"], ["Honduras", "HN"], ["Hong Kong", "HK"], ["Hungary", "HU"], ["Iceland", "IS"], ["India", "IN"], ["Indonesia", "ID"], ["Iraq", "IQ"], ["Ireland, Northern", "GB"], ["Ireland, Republic Of", "IE"], ["Israel", "IL"], ["Italy", "IT"], ["Ivory Coast", "CI"], ["Jamaica", "JM"], ["Japan", "JP"], ["Jordan", "JO"], ["Jost Van Dyke Island", "VG"], ["Kazakhstan", "KZ"], ["Kenya", "KE"], ["Korea, South (South Korea)", "KR"], ["Kuwait", "KW"], ["Kyrgyzstan", "KG"], ["Laos", "LA"], ["Latvia", "LV"], ["Lebanon", "LB"], ["Lesotho", "LS"], ["Liberia", "LR"], ["Libya", "LY"], ["Liechtenstein", "LI"], ["Lithuania", "LT"], ["Luxembourg", "LU"], ["Macau", "MO"], ["Macedonia", "MK"], ["Madagascar", "MG"], ["Malawi", "MW"], ["Malaysia", "MY"], ["Maldives, Republic Of", "MV"], ["Mali", "ML"], ["Malta", "MT"], ["Marshall Islands", "MH"], ["Martinique", "MQ"], ["Mauritania", "MR"], ["Mauritius", "MU"], ["Mexico", "MX"], ["Micronesia", "FM"], ["Moldova", "MD"], ["Monaco", "MC"], ["Mongolia", "MN"], ["Montenegro", "ME"], ["Montserrat", "MS"], ["Morocco", "MA"], ["Mozambique", "MZ"], ["Namibia", "NA"], ["Nepal", "NP"], ["Netherlands (Holland)", "NL"], ["Netherlands Antilles (Caribbean)", "AN"], ["Nevis", "KN"], ["New Caledonia", "NC"], ["New Guinea", "PG"], ["New Zealand", "NZ"], ["Nicaragua", "NI"], ["Niger", "NE"], ["Nigeria", "NG"], ["Norfolk Island", "AU"], ["Norman Island", "VG"], ["Norway", "NO"], ["Oman", "OM"], ["Pakistan", "PK"], ["Palau", "PW"], ["Panama", "PA"], ["Papua New Guinea", "PG"], ["Paraguay", "PY"], ["Peru", "PE"], ["Philippines", "PH"], ["Poland", "PL"], ["Portugal", "PT"], ["Puerto Rico", "US"], ["Qatar", "QA"], ["Reunion", "RE"], ["Romania", "RO"], ["Rota", "MP"], ["Russia", "RU"], ["Rwanda", "RW"], ["Saba", "AN"], ["Saipan", "MP"], ["San Marino", "IT"], ["Saudi Arabia", "SA"], ["Scotland", "GB"], ["Senegal", "SN"], ["Serbia", "RS"], ["Seychelles", "SC"], ["Singapore", "SG"], ["Slovak Republic", "SK"], ["Slovenia", "SI"], ["South Africa, Republic Of", "ZA"], ["Spain", "ES"], ["Sri Lanka", "LK"], ["St. Barthelemy", "GP"], ["St. Christopher", "KN"], ["St. Croix Island", "VI"], ["St. Eustatius", "AN"], ["St. John", "VI"], ["St. Kitts And Nevis", "KN"], ["St. Lucia", "LC"], ["St. Maarten", "AN"], ["St. Martin", "AN"], ["St. Thomas", "VI"], ["St. Vincent", "VC"], ["Suriname", "SR"], ["Swaziland", "SZ"], ["Sweden", "SE"], ["Switzerland", "CH"], ["Syria", "SY"], ["Tahiti", "PF"], ["Taiwan, Republic Of China", "TW"], ["Tanzania", "TZ"], ["Thailand", "TH"], ["Tinian", "MP"], ["Togo", "TG"], ["Tortola Island", "VG"], ["Trinidad And Tobago", "TT"], ["Tunisia", "TN"], ["Turkey", "TR"], ["Turks And Caicos Islands", "TC"], ["US Virgin Islands", "VI"], ["Uganda", "UG"], ["Ukraine", "UA"], ["Union Island", "VC"], ["United Arab Emirates", "AE"], ["United Kingdom", "GB"], ["United States", "US"], ["Uruguay", "UY"], ["Uzbekistan", "UZ"], ["Vanuatu", "VU"], ["Vatican City", "IT"], ["Venezuela", "VE"], ["Vietnam", "VN"], ["Wales (United Kingdom)", "GB"], ["Wallis & Futuna Islands", "WF"], ["Yemen, The Republic Of", "YE"], ["Zambia", "ZM"], ["Zimbabwe", "ZW"]]

  # SHIPPING_COUNTRIES = ['Afghanistan - AF', 'Albania - AL', 'Algeria - DZ', 'American Samoa - AS', 'Andorra - AD', 'Angola - AO', 'Anguilla - AI', 'Antigua - AG', 'Argentina - AR', 'Armenia - AM', 'Aruba - AW', 'Australia - AU', 'Austria - AT', 'Azerbaijan - AZ', 'Bahamas - BS', 'Bahrain - BH', 'Bangladesh - BD', 'Barbados - BB', 'Barbuda - AG', 'Belarus - BY', 'Belgium - BE', 'Belize - BZ', 'Benin - BJ', 'Bermuda - BM', 'Bhutan - BT', 'Bolivia - BO', 'Bonaire - AN', 'Bosni - BA', 'Botswana - BW', 'Brazil - BR', 'British Guyana - GY', 'British Virgin Islands - VG', 'Brunei - BN', 'Bulgaria - BG', 'Burkina Faso - BF', 'Burundi - BI', 'Cambodia - KH', 'Cameroon - CM', 'Canada - CA', 'Canary Islands - ES', 'Cape Verde - CV', 'Cayman Islands - KY', 'Chad - TD', 'Channel Islands - GB', 'Chile - CL', 'China, PeopleS Republic Of - CN', 'Colombia - CO', 'Congo - CG', 'Congo, Dem Rep Of - CD', 'Cook Islands - CK', 'Costa Rica - CR', 'Croatia - HR', 'Curacao - AN', 'Cyprus - CY', 'Czech Republic - CZ', 'Denmark - DK', 'Djibouti - DJ', 'Dominica - DM', 'Dominican Republic - DO', 'Ecuador - EC', 'Egypt - EG', 'El Salvador - SV', 'England (United Kingdom) - GB', 'Eritrea - ER', 'Estonia - EE', 'Ethiopia - ET', 'Faeroe Islands - FO', 'Fiji - FJ', 'Finland - FI', 'France - FR', 'French Guiana - GF', 'French Polynesia - PF', 'Gabon - GA', 'Gambia - GM', 'Georgia, Republic Of - GE', 'Germany - DE', 'Ghana - GH', 'Gibraltar - GI', 'Grand Cayman - KY', 'Great Britain - GB', 'Great Thatch Island - VG', 'Great Tobago Island - VG', 'Greece - GR', 'Greenland - GL', 'Grenada - GD', 'Guadeloupe - GP', 'Guam - GU', 'Guatemala - GT', 'Guinea - GN', 'Guyana - GY', 'Guyane - GF', 'Haiti - HT', 'Holland - NL', 'Honduras - HN', 'Hong Kong - HK', 'Hungary - HU', 'Iceland - IS', 'India - IN', 'Indonesia - ID', 'Iraq - IQ', 'Ireland, Northern - GB', 'Ireland, Republic Of - IE', 'Israel - IL','Italy - IT', 'Ivory Coast - CI', 'Jamaica - JM', 'Japan - JP', 'Jordan - JO', 'Jost Van Dyke Island - VG', 'Kazakhstan - KZ', 'Kenya - KE', 'Korea, South (South Korea) - KR', 'Kuwait - KW', 'Kyrgyzstan - KG', 'Laos - LA', 'Latvia - LV', 'Lebanon - LB', 'Lesotho - LS', 'Liberia - LR', 'Libya - LY', 'Liechtenstein - LI', 'Lithuania - LT', 'Luxembourg - LU', 'Macau - MO', 'Macedonia - MK', 'Madagascar - MG', 'Malawi - MW', 'Malaysia - MY', 'Maldives, Republic Of - MV', 'Mali - ML', 'Malta - MT', 'Marshall Islands - MH', 'Martinique - MQ', 'Mauritania - MR', 'Mauritius - MU', 'Mexico - MX', 'Micronesia - FM', 'Moldova - MD', 'Monaco - MC', 'Mongolia - MN', 'Montenegro - ME', 'Montserrat - MS','Morocco - MA', 'Mozambique - MZ', 'Namibia - NA', 'Nepal - NP', 'Netherlands (Holland) - NL', 'Netherlands Antilles (Caribbean) - AN', 'Nevis - KN', 'New Caledonia - NC', 'New Guinea - PG', 'New Zealand - NZ', 'Nicaragua - NI', 'Niger - NE', 'Nigeria - NG', 'Norfolk Island - AU', 'Norman Island - VG', 'Norway - NO', 'Oman - OM', 'Pakistan - PK', 'Palau - PW', 'Panama - PA', 'Papua New Guinea - PG', 'Paraguay - PY', 'Peru - PE', 'Philippines - PH', 'Poland - PL', 'Portugal - PT', 'Puerto Rico - US', 'Qatar - QA', 'Reunion - RE', 'Romania - RO', 'Rota - MP', 'Russia - RU', 'Rwanda - RW', 'Saba - AN', 'Saipan - MP', 'San Marino - IT', 'Saudi Arabia - SA', 'Scotland - GB', 'Senegal - SN', 'Serbia - RS', 'Seychelles - SC', 'Singapore - SG', 'Slovak Republic - SK', 'Slovenia - SI', 'South Africa, Republic Of - ZA', 'Soviet Union - ON',  'Spain - ES', 'Sri Lanka - LK', 'St. Barthelemy - GP', 'St. Christopher - KN', 'St. Croix Island - VI', 'St. Eustatius - AN', 'St. John - VI', 'St. Kitts And Nevis - KN', 'St. Lucia - LC', 'St. Maarten - AN', 'St. Martin - AN', 'St. Thomas - VI', 'St. Vincent - VC', 'Suriname - SR', 'Swaziland - SZ', 'Sweden - SE', 'Switzerland - CH', 'Syria - SY', 'Tahiti - PF', 'Taiwan, Republic Of China - TW', 'Tanzania - TZ', 'Thailand - TH', 'Tinian - MP', 'Togo - TG', 'Tortola Island - VG', 'Trinidad And Tobago - TT', 'Tunisia - TN', 'Turkey - TR', 'Turks And Caicos Islands - TC', 'US Virgin Islands - VI', 'Uganda - UG', 'Ukraine - UA', 'Union Island - VC', 'United Arab Emirates - AE', 'United Kingdom - GB', 'Uruguay - UY', 'Uzbekistan - UZ', 'Vanuatu - VU', 'Vatican City - IT', 'Venezuela - VE', 'Vietnam - VN', 'Virgin Islands - DS',  'Wales (United Kingdom) - GB', 'Wallis & Futuna Islands - WF', 'Yemen, The Republic Of - YE', 'Zaire - ZR', 'Zambia - ZM', 'Zimbabwe - ZW']

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

    def provinces code
      country =  Country.find_country_by_alpha2(code)
      begin
        country.states.collect {|abbreviation, province| [province['name'], abbreviation]}
      rescue
        []
      end
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

    def get_country country
      country_code = ''
      country_code += country.slice(country.length - 2)
      country_code += country.slice(country.length - 1)
    end
  end
end
