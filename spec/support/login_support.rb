def login_with_dh login, password
  visit '/'

  binding.pry
  fill_in '#user_login', with: login
  fill_in '#user_password', with: password

  click_button 'Login'
end
