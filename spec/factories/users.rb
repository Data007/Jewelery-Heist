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

    factory :web_user do
      name 'Web User'
      first_name 'Web'
      last_name 'User'
      login 'webuser'
    end
  end
end
