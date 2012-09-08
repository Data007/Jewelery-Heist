FactoryGirl.define do
  factory :item do
    name 'Dev_Item'
    description 'Development Item'
    price 10.0
    quantity 2
    published true
    available true
    ghost false
  end
end
