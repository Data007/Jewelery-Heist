desc 'Removing phones stored as string and moving them as objects'
task phone_string_to_object: :environment do
  User.all.each do |user|
    begin
      user.phones
    rescue NoMethodError
      # need to grab the phone strings and then put them as phone objects still. Below is just code to nil out the phones. Mike pick up from here.
      binding.pry
      user.set(:phones, [])
    end
  end
end
