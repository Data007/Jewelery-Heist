FactoryGirl.define do
  factory :address do
    address_1 '2345 S. Yyuoping RD'
    city 'hitgury'
    province 'MI'
    postal_code '6478'
    country 'US'

    factory :valid_shipping_address do
    end

  end
end
