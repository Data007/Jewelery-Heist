FactoryGirl.define do
  factory :item do
    name 'Dev_Item'
    description 'Development Item'
    price 10.0
    quantity 2
    published true
    available true
    ghost false
    
    after :create do |item, evaluator|
      FactoryGirl.create_list :asset, 1, item: item
    end
  end
end
