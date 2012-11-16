FactoryGirl.define do
  factory :address do
    address_1 '2236 S 33 1/2 RD'
    city 'cadillac'
    province 'MI'
    postal_code '49601'
    country 'US'

    factory :shipping_address do
    end

    factory :international_address do
      address_1 '25 Raglan Street, Ste. 20'
      city 'TORONTO'
      postal_code 'M5V 2Z9'
      province 'ON'
      country 'CA'
    end

    factory :international_england_address do
      address_1 'Chiswick Lane South'
      city 'London'
      postal_code 'W4 2QB'
      province 'EN'
      country 'GB'
    end
  end
end
