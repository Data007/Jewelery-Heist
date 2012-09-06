# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'User'
    password 'password'
    password_confirmation {|user| user.password}

    factory :web_user do
      name 'Web User'
      login 'webuser'
    end
  end
end
