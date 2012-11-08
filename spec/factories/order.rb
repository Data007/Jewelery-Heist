FactoryGirl.define do
  factory :order do
    refunded false
    ship false
    purchased false
    location 'website'
    notes 'testing order'
  end
end
