FactoryGirl.define do
  factory :address do
    address_1 '2236 S 33 1/2 RD'
    city 'cadillac'
    province 'MI'
    postal_code '49601'
    country 'US'

    factory :shipping_address do
    end

  end
end
