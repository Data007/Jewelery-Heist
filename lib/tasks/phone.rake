desc 'Removing phones stored as string and moving them as objects'
task phone_string_to_object: :environment do
  User.all.each do |user|
    puts "0.0\nReviewing phone number for #{user.full_name} (##{user.id})"
    begin
      user.phones
      puts '  - Phone numbers already ported ... Skipping'
    rescue
      new_phone_list = []
      user[:phones].each do |phone_string|
        puts "  - Found old phone number #{phone_string}"
        print '  - Porting old phone number to new phone number ... '
        new_phone_list << Phone.new(number: phone_string)
        puts 'Done'
      end
      user[:phones] = new_phone_list if new_phone_list.present?
      begin
        user.save
      rescue
        user.phones = []
        new_phone_list.each do |phone|
          user.phones.create number: phone.number
        end
        user.save
      end
    end
  end
end
