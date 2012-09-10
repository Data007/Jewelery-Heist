def login_with_dh email, password
  visit '/'

  fill_in 'user_email', with: email
  fill_in 'user_password', with: password

  click_button 'Login'
end
