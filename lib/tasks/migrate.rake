namespace :migrate do

  desc "Migrate Users"
  task :users => :environment do

    print '   - Gathering users ... '
    migrating_users = HTTParty.get('http://localhost:3003/migrate_data/for_users')
    puts 'done'

    print '   - Clearing current users ... '
    User.destroy_all
    puts 'done'

    puts '   - Creating new users ... '
    migrating_users.each do |user|
      user     = user['user']

      print "  -- Creating #{user['name']} ... "
      new_user = User.create({
        name:          user['name'],
        login:         user['login'],
        password_hash: user['password'],
        is_active:     user['is_active']
      })
      puts 'done'
    
      puts ' --- Adding email addresses ... '
      user['emails'].each do |email|
        print "---- Adding #{email['address']} ... "
        new_user.emails << email['address'] unless new_user.emails.include? email['address']
        puts 'done'
      end
      puts ' --- Adding email addresses ... done'

      puts ' --- Adding phone numbers ... '
      user['phones'].each do |phone|
        print "---- Adding #{phone['number']} ... "
        new_user.phones << phone['number'] unless new_user.phones.include? phone['number']
        puts 'done'
      end
      puts ' --- Adding phone numbers ... done'

      puts ' --- Adding addresses ... '
      user['addresses'].each do |address|
        print "---- Adding #{address['address_1']}, #{address['address_2']}, #{address['city']}, #{address['province']} #{address['postal_code']} #{address['country']} ... "
        new_user.addresses.find_or_create_by({
          address_1:   address['address_1'],
          address_2:   address['address_2'],
          city:        address['city'],
          province:    address['province'],
          postal_code: address['postal_code'],
          country:     address['country']
        })
        puts 'done'
      end
      puts ' --- Adding addresses ... done'

    end
    puts '   - Creating new users ... done'

  end

end
