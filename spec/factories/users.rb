# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'DragonHoard User'
    first_name 'DragonHoard'
    last_name 'User'
    password 'password'
    password_confirmation {|user| user.password}
    is_active true
    email 'dh@example.com'
    email_confirmation 'dh@example.com'

    factory :user_with_phone_address do
      after(:create) do |user, evaluator|
        FactoryGirl.create :phone, user: user
        FactoryGirl.create :address, user: user
      end
    end

    factory :web_user do
      name 'Web User'
      first_name 'Web'
      last_name 'User'
      login 'webuser'

    factory :web_user_with_test_email_address
      email 'bryan@deepwoodsbrigade.com'
      email_confirmation 'bryan@deepwoodsbrigade.com'

      factory :web_user_with_address do
        after(:create) do |web_user, evaluator|
          FactoryGirl.create :phone, user: web_user
          FactoryGirl.create :address, user: web_user
        end
      end

      factory :web_user_with_international_address do
        after(:create) do |web_user, evaluator|
          FactoryGirl.create :phone, user: web_user
          FactoryGirl.create :international_address, user: web_user
        end
      end

      factory :web_user_with_international_europe_address do
        after(:create) do |web_user, evaluator|
          FactoryGirl.create :phone, user: web_user
          FactoryGirl.create :international_england_address, user: web_user
        end
      end

      factory :web_user_with_order do
        after(:create) do |web_user, evaluator|
          FactoryGirl.create :order, user: web_user
        end
      end

      factory :phone_migration_user do
        name 'phone user'
        first_name 'phone'
        last_name 'user'
      end
    end
  end
end
