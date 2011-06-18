# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.name                  'test'
  f.login                 'test'
  f.password              'password'
  f.password_confirmation 'password'
end
