def safe_image_name(name)
  name.gsub(' ', '-')
end

def store_image(url, image_name)
  host       = url.split('/')[2]
  path       = "/#{url.split('/')[3..-1].join('/').gsub(/\?.*$/, '')}"
  pid        = Process.pid
  
  unless Dir.exists? "#{Rails.root}/tmp/#{pid}"
    system "mkdir #{Rails.root}/tmp/#{pid}"
  end

  image_path = "#{Rails.root}/tmp/#{pid}/#{safe_image_name(image_name)}"
  
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

DOMAIN = 'localhost:3003'

namespace :migrate do

  desc "Migrate Users"
  task :users => :environment do

    print '   - Gathering users ... '
    migrating_users = HTTParty.get("http://#{DOMAIN}/migrate_data/for_users?migration_token=#{migration_token}")
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

    migrating_items = MultiJson.decode(open("http://#{DOMAIN}/migrate_data/for_items?migration_token=#{migration_token}"))

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

          variation_details = MultiJson.decode(open("http://#{DOMAIN}/migrate_data/details_for_variation/#{variation['id']}?migration_token=#{migration_token}"))
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
          new_variation.metal_csv = variation_details['metal']['name'] if variation_details['metal']
          new_variation.save
          puts 'done'

          print "---- Adding finishes to variation #{new_variation.id} ... "
          new_variation.finish_csv = variation_details['finish']['name'] if variation_details['finish']
          new_variation.save
          puts 'done'

          print "---- Adding jewels to variation #{new_variation.id} ... "
          new_variation.jewel_csv = variation_details['jewel']['name'] if variation_details['jewel']
          new_variation.save
          puts 'done'

        end
        
        assets = MultiJson.decode(open("http://#{DOMAIN}/migrate_data/assets_for_variation/#{variation['id']}?migration_token=#{migration_token}"))['assets']
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
        print "---- Creating asset #{asset.image_file_name} ... "

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
  task :orders => :environment do
    uri      = "http://#{DOMAIN}/migrate_data/for_orders?migration_token=#{migration_token}"
    response = HTTParty.get(uri)

    pages        = response['pages']
    total_pages  = pages['total_pages']
    current_page = 1

    while current_page <= total_pages do
      current_uri = uri + "&page=#{current_page}"
      print "   - Connecting to url #{current_uri} ... "
      response = HTTParty.get(current_uri)
      puts 'done'
            
      response['orders'].each do |order|
        print "  -- Updating user #{order['user']['name']} ... "
        user = User.where(name: order['user']['name'])
        user = user.present? ? user.first : User.create(name: order['user']['name'])
        user.update_attributes({
          created_at: order['user']['created_at'],
          custom_id:  order['user']['id'],
          login:      order['user']['login'],
          password:   order['user']['password'],
          role:       order['user']['role_name'] == 'owner' ? 'admin' : order['user']['role_name'],
          is_active:  true
        })

        user.emails << order['user']['email'] unless user.emails.include?(order['user']['email'])
        user.phones << order['user']['phone'] unless user.phones.include?(order['user']['phone'])
        puts 'done'
# Sample Order: {"current_url"=>nil, "completed_at"=>nil, "city"=>"Cadillac", "staging_type"=>"repair", "refunded"=>false, "location"=>"instore", "item_notes"=>"10K yg Tigers Eye Ring", "created_at"=>2010-11-29 09:51:21 -0700, "country"=>"US", "based_on_item_ids"=>nil, "updated_at"=>2010-12-17 10:40:48 -0700, "stones"=>nil, "postal_code"=>"49601", "notes"=>nil, "show_wax"=>true, "molds"=>nil, "id"=>219299, "clerk_id"=>36, "user_id"=>975, "ship"=>false, "purchased_at"=>2010-12-17 10:40:48 -0700, "ghost"=>false, "address_1"=>"2850 S. 35 1/2 Mile Rd.", "phones"=>nil, "metals"=>nil, "emails"=>nil, "address_2"=>"", "shipping_option"=>nil, "repair_notes"=>"Polish stone Sending to Korner Stone Gems\r\n\r\n\r\nCustomer needs by Christmas.", "current_head_method"=>nil, "province"=>"MI", "handed_off"=>false, "due_at"=>"3 weeks"}

# find order or create it
        new_order = user.orders.where(custom_id: order['id'])
        new_order = new_order.present? ? new_order.first : user.orders.create(custom_id: order['id'])
        new_order.update_attributes({
          based_on_item_ids:   order['based_on_item_ids'],
          current_head_method: order['current_head_method'],
          current_url:         order['current_url'],
          clerk_id:            order['clerk_id'],
          completed_at:        order['completed_at'],
          purchased_at:        order['purchased_at'],
          due_at:              order['due_at'],
          created_at:          order['created_at'],
          refunded:            order['refunded'],
          handed_off:          order['handed_off'],
          staging_type:        order['staging_type'],
          location:            order['location'],
          item_notes:          order['item_notes'],
          repair_notes:        order['repair_notes'],
          notes:               order['notes'],
          metals:              order['metals'],
          stones:              order['stones'],
          molds:               order['molds'],
          show_wax:            order['show_wax'],
          address_1:           order['address_1'],
          address_2:           order['address_2'],
          city:                order['city'],
          province:            order['province'],
          country:             order['country'],
          postal_code:         order['postal_code'],
          shipping_option:     order['shipping_option'],
          ship:                order['ship']
        })

        order['line_items'].each do |line_item|
          if line_item['variation']
            print " --- Finding variation #{line_item['variation']['id']} ... "
            new_variation = Variation.find_by_custom_id(line_item['variation_id'])
            puts 'done'
          end

          print " --- Updating line_item #{line_item['id']} for order #{order['id']} ... "
          new_line_item = new_order.line_items.where(custom_id: line_item['id'])
          new_line_item = new_line_item.present? ? new_line_item.first : new_order.line_items.new(custom_id: line_item['id'], price: line_item['price'])
          new_line_item.variation = new_variation if new_variation
          new_line_item.price = 0 if (line_item['price'].nil? && !new_variation)
          new_line_item.save
          new_line_item.update_attributes({
            name:          line_item['name'],
            size:          line_item['size'],
            refunded:      line_item['refunded'],
            created_at:    line_item['created_at'],
            quantity:      line_item['quantity'],
            is_service:    line_item['is_service'],
            is_quick_item: line_item['is_quick_item'],
            taxable:       line_item['taxable'],
            quick_id:      line_item['quick_id'],
            description:   line_item['description']
          })
          puts 'done'
        end
        # Line Items: "line_items"=>[{"price"=>35.0, "name"=>"Polish Stone", "size"=>"0", "refunded"=>false, "created_at"=>2010-11-29 09:53:41 -0700, "quantity"=>1, "updated_at"=>2010-11-29 09:53:41 -0700, "order_id"=>219299, "is_service"=>true, "is_quick_item"=>true, "taxable"=>false, "id"=>1560, "quick_id"=>"n/a", "ghost"=>false, "variation_id"=>nil, "description"=>"10K yg Tigers Eye Ring"}]
          # find variation/item or create it

# find payment or create it
        order['payments'].each do |payment|
          print " --- Updating payment #{payment['id']} for order #{order['id']} ... "
          new_payment = new_order.payments.where(custom_id: payment['id'])
          new_payment = new_payment.present? ? new_payment.first : new_order.payments.create(custom_id: payment['id'])
          new_payment.update_attributes({
            amount:       payment['amount'],
            payment_type: payment['payment_type']['name'].downcase,
            check_number: payment['check_number'],
            created_at:   payment['created_at']
          })
          puts 'done'
        end
        # Payment: "payments"=>[{"created_at"=>2010-12-17 10:40:48 -0700, "check_number"=>"", "payment_type"=>{"name"=>"MasterCard", "created_at"=>2010-05-26 09:07:56 -0700, "updated_at"=>2010-05-26 09:07:56 -0700, "id"=>1}, "updated_at"=>2010-12-17 10:40:48 -0700, "order_id"=>219299, "amount"=>35.0, "id"=>1096, "payment_type_id"=>1}]
      end

      current_page += 1
    end
  end

end
