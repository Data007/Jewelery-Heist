FactoryGirl.define do
  factory :order do
    refunded false
    ship false
    purchased false
    notes 'testing order'
  end
end
