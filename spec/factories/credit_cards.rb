# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    number '1234567890123456'
    date '04/05/1221'
    ccv_code '675'
    name_on_card 'John Doe'
  end
end
