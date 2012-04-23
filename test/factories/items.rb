# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    size_range '6-10'
    name       'test item'
  end
end
