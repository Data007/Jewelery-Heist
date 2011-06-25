# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.name                  'test user'
  f.login                 'test'
  f.password              'password'
  f.password_confirmation 'password'
  f.is_active             true
end

Factory.define :admin, parent: :user do |f|
  f.name  'admin user'
  f.login 'admin'
  f.role  'admin'
end

Factory.define :customer, parent: :user do |f|
  f.name  'customer user'
  f.login 'customer'
end
