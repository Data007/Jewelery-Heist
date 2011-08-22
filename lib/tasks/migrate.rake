def store_image(url, image_name)
  host       = url.split('/')[2]
  path       = "/#{url.split('/')[3..-1].join('/').gsub(/\?.*$/, '')}"
  pid        = Process.pid
  
  unless Dir.exists? "#{Rails.root}/tmp/#{pid}"
    system "mkdir #{Rails.root}/tmp/#{pid}"
  end

  image_path = "#{Rails.root}/tmp/#{pid}/#{image_name}"
  
  Net::HTTP.start(host) do |http|
    response = http.get(path)
    open(image_path, 'wb') do |file|
      file.write(response.body)
    end
  end
  image_path
end

def migration_token
  "f1a649db463bc07dcb9f4627ccdf1957760978c23b90be9ee05947c77141d1b5"
end

namespace :migrate do

  desc "Migrate Users"
  task :users => :environment do

    print '   - Gathering users ... '
    migrating_users = HTTParty.get("http://wexfordjewelers.com/migrate_data/for_users?migration_token=#{migration_token}")
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
        is_active:     true,
        role:          user['role_name'] == 'owner' ? 'admin' : user['role_name']

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

    migrating_items = MultiJson.decode(open("http://wexfordjewelers.com/migrate_data/for_items?migration_token=#{migration_token}"))

    puts '   - Creating items ...'
    migrating_items.each do |item|
      
      print "  -- Creating item #{item['name']} ... "
      if item['designer']
        designer = User.where(name: item['designer']['name']).first
        designer.update_attribute :designer, true
      end
      new_item = Item.where(custom_id: item['id'])
      new_item = new_item.present? ? new_item.first : Item.create(name: item['name'])
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
        discountinued_notes: item['discontinued_notes'],
               customizable: item['customizable'],
         customizable_notes: item['customizable_notes']
      })
      puts 'done'

      puts " --- Creating collections for #{item['name']} ..."
      item['collections'].each do |collection|

        unless collection['ghost']
          print "---- Creating collection #{collection['name']} ... "
          new_collection = Collection.where(custom_id: collection['id'])
          new_collection = new_collection.present? ? new_collection.first : Collection.create
          
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
            new_variation = new_item.variations.where(custom_id: variation['id'])
            new_variation = new_variation.present? ? new_variation.first : new_item.variations.create
            new_variation.update_attributes({
                    custom_id: variation['id'],
                        price: variation['price'],
              backorder_notes: variation['backorder_notes']
            })
          puts "done"

          variation_details = MultiJson.decode(open("http://wexfordjewelers.com/migrate_data/details_for_variation/#{variation['id']}?migration_token=#{migration_token}"))
          puts "---- Found #{variation_details['colors'].length} colors in variation #{new_variation.id} ... "
          variation_details['colors'].each do |color|
            print "---- Creating colors #{color['names']} ... "
            new_color = Color.where(names: color['names'])
            new_color = new_color.present? ? new_color.first : Color.create
            new_color.update_attributes({
                 names: color['names'],
              position: color['position']
            })

            new_variation.colors = (new_variation.colors + [new_color]).compact.uniq
            new_variation.save
            puts 'done'
          end
          puts "---- Found #{variation_details['colors'].length} colors in variation #{new_variation.id} ... done"

          print "---- Adding metals to variation #{new_variation.id} ... "
          new_variation.metal_csv = variation_details['metal']['name'] if variation['metal']
          new_variation.save
          puts 'done'

          print "---- Adding finishes to variation #{new_variation.id} ... "
          new_variation.finish_csv = variation_details['finish']['name'] if variation['finish']
          new_variation.save
          puts 'done'

          print "---- Adding jewels to variation #{new_variation.id} ... "
          new_variation.jewel_csv = variation_details['jewel']['name'] if variation['jewel']
          new_variation.save
          puts 'done'

        end
        
        assets = MultiJson.decode(open("http://wexfordjewelers.com/migrate_data/assets_for_variation/#{variation['id']}?migration_token=#{migration_token}"))['assets']
        puts "---- Found #{assets.length} assets in variation #{new_variation.id} ... "
        assets.each do |asset|
          if (asset['image_url'] && asset['image_file_name'])
            print "---- Creating asset #{asset['image_file_name']} ... "
            begin
              # image_path = store_image(asset['image_url'], asset['image_file_name'])
              
              if new_variation.assets.where(image_file_name: asset['image_file_name']).empty?
                new_asset = new_variation.assets.create(migratory_url: asset['image_url'], image_file_name: asset['image_file_name'])
              else
                new_asset = new_variation.assets.where(image_file_name: asset['image_file_name']).first
                new_asset.migratory_url = asset['image_url']
              end
              
              new_asset.position = asset['position']
              new_asset.save
              new_variation.save
              
            rescue => e
              print " no valid asset found ... #{e} ... "
            end
            
            puts 'done'
          end
        end
        puts "---- Found #{assets.length} assets in variation #{new_variation.id} ... done"

      end
      puts " --- Creating variations for #{item['name']} ... done"
      
    end
    puts '   - Creating items ... done'

  end

  desc 'Update images'
  task :images => :environment do
    Item.all.map(&:variations).flatten.each do |variation|
      puts "---- Found #{variation.assets.length} assets in variation #{variation.id} ... "
      variation.assets.where(migrated: false).each do |asset|
        print "---- Creating asset #{asset['image_file_name']} ... "

        image_path = store_image(asset.migratory_url, asset.image_file_name)
        image = File.open(image_path)

        asset.image = image

        asset.save
        variation.save

        asset.update_attribute :migrated, true

        puts 'done'
      end
      puts "---- Found #{variation.assets.length} assets in variation #{variation.id} ... done"

      print '---- Sorting assets by position ... '
      variation.assets.each do |asset|
        variation.update_asset_position(asset, asset.position)
      end
      puts 'done'
    end
    
    system "rm -Rf #{Rails.root}/tmp/#{Process.pid}"

  end

  desc 'Find or create orders'
  task :orders => [:users, :items] do
    migrating_orders = MultiJson.decode(open("http://wexfordjewelers.com/migrate_data/for_orders?migration_token=#{migration_token}"))
    
  end

end
