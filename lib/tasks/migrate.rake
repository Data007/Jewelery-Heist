namespace :migrate do

  desc "Migrate Users"
  task :users => :environment do

    print '   - Gathering users ... '
    migrating_users = HTTParty.get('http://localhost:3003/migrate_data/for_users')
    puts 'done'

    print '   - Creating Wexford User ... '
    wexford_user = User.where(name: 'Wexford Jewelers').first || User.create(name: 'Wexford Jewelers')
    puts 'done'

    puts '   - Creating new users ... '
    migrating_users.each do |user|

      print "  -- Creating #{user['name']} ... "
      new_user = User.where(login: user['login']).first || User.create(name: user['name'])
      new_user.update_attributes({
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

  desc 'Migrate Items'
  task :items => :environment do

    migrating_items = MultiJson.decode(open('http://localhost:3003/migrate_data/for_items'))

    puts '   - Creating items ...'
    migrating_items.each do |item|
      
      print "  -- Creating item #{item['name']} ... "
      if item['designer']
        designer = User.where(name: item['designer']['name']).first
        designer.update_attribute :designer, true
      end
      new_item = Item.where(custom_id: item['id']).first || Item.create
      new_item.update_attributes({
                       name: item['name'],
                description: item['description'],
                 size_range: item['size_range'],
                  custom_id: item['id'],
                designer_id: (designer.id if item['designer']),
                     gender: (item['gender']['name'] if item['gender']),
                   category: (item['category']['name'].downcase if item['category']),
                       cost: item['cost'],
                  available: item['available'],
                  published: item['published'],
              one_of_a_kind: item['one_of_a_kind'],
        discountinued_notes: item['discontinued_votes'],
               customizable: item['customizable'],
         customizable_notes: item['customizable_notes']
      })
      puts 'done'

      puts " --- Creating collections for #{item['name']} ..."
      item['collections'].each do |collection|

        unless collection['ghost']
          print "---- Creating collection #{collection['name']} ... "
          new_collection = Collection.where(custom_id: collection['id']).first || Collection.create
          new_collection.update_attributes({
                   name: collection['name'],
            description: collection['description'],
              custom_id: collection['id']
          })
          new_item.collections << new_collection unless new_item.collections.include?(new_collection)
          puts 'done'
        end

      end
      puts " --- Creating collections for #{item['name']} ... done"

      puts " --- Creating variations for #{item['name']} ..."
      item['variations'].each do |variation|

        unless variation['ghost']
          print "---- Creating variation #{variation['id']} ... "
            new_variation = new_item.variations.where(custom_id: variation['id']).first || new_item.variations.create
            new_variation.update_attributes({
                    custom_id: variation['id'],
                        price: variation['price'],
              backorder_notes: variation['backorder_notes']
            })
          puts "done"

          puts "---- Found #{variation['colors'].length} colors in variation #{new_variation.id} ... "
          variation['colors'].each do |color|
            print "---- Creating colors #{color['names']} ... "
            new_color = Color.where(names: color['names']).first || Color.create
            new_color.update_attributes({
                 names: color['names'],
              position: color['position']
            })

            new_variation.colors = (new_variation.colors + [new_color]).compact.uniq
            new_variation.save
            puts 'done'
          end
          puts "---- Found #{variation['colors'].length} colors in variation #{new_variation.id} ... done"

          puts "---- Found #{variation['assets'].length} assets in variation #{new_variation.id} ... "
          variation['assets'].each do |asset|
            print '---- Creating assets ... '
            debugger
            new_variation.assets.create(asset) if new_variation.assets.where(image_file_name: asset['image_file_name']).empty?
            new_variation.save
            puts 'done'
          end
          puts "---- Found #{variation['assets'].length} assets in variation #{new_variation.id} ... done"

          print "---- Adding metals to variation #{new_variation.id} ... "
          new_variation.metal_csv = variation['metal']['name'] if variation['metal']
          new_variation.save
          puts 'done'

          print "---- Adding finishes to variation #{new_variation.id} ... "
          new_variation.finish_csv = variation['finish']['name'] if variation['finish']
          new_variation.save
          puts 'done'

          print "---- Adding jewels to variation #{new_variation.id} ... "
          new_variation.jewel_csv = variation['jewel']['name'] if variation['jewel']
          new_variation.save
          puts 'done'

        end

      end
      puts " --- Creating variations for #{item['name']} ... done"
      
    end
    puts '   - Creating items ... done'

  end

end
