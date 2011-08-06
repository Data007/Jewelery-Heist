# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :item do |f|
  f.size_range '6-10'
  f.name       'test item'
end
