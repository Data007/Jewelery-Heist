# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name                  'test user'
    login                 'test'
    password              'password'
    password_confirmation 'password'
    is_active             true

    factory :admin do
      name  'admin user'
      login 'admin'
      role  'admin'
    end

    factory :customer do
      name  'customer user'
      login 'customer'
      after_create do |customer|
        customer.addresses.create!({
          address_1: '801 N. MITCHELL ST.',
          city:      'CADILLAC',
          province:  'MI',
          postal_code: '49601'
        })
      end
    end
  end
end
