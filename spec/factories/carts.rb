# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart do
    factory :anonymous_cart_ready_for_payments do
      first_name 'Anonymous'
      last_name  'User'
      email      'anon@example.com'
      phone      '1234567890'

      after(:create) do |cart, evaluator|
        FactoryGirl.create :valid_shipping_address
      end
    end
  end
end
