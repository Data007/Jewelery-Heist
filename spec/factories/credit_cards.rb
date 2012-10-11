# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    number '1234567890123456'
    month '04'
    year '12'
    ccv '675'
    name 'John Doe'
  end
end
