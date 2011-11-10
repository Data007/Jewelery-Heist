class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :position,     type: Integer
  field :migratory_url
  field :migrated,     type: Boolean, default: false

  scope :by_position, order_by([[:position, :desc]])

  has_mongoid_attached_file :image,
    styles: {
      tiny:      "100x80",
      thumbnail: "100x120",
      small:     "160x120",
      medium:    "280x240",
      large:     "520x480",
      manage:    "340x313"
    },
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/#{Rails.env}_s3.yml",
    s3_headers: {
      content_type:        'application/octet-stream',
      content_disposition: 'attachment'
    },
    s3_protocol: 'https',
    path: "variation/:attachment/:id/:basename-:style.:extension",
    url:  ":s3_domain_url"
  
  embedded_in :variation

  def refresh_image
    image_path = store_image(migratory_url, image_file_name)
    new_image = File.open(image_path)

    image = new_image

    save
  end

private

  def safe_image_name(name)
    name.gsub(' ', '-')
  end

  def store_image(url, image_name)
    print ' - Setting up image paths ... '
    
    host       = url.split('/')[2]
    path       = "/#{url.split('/')[3..-1].join('/').gsub(/\?.*$/, '')}"
    pid        = Process.pid

    puts 'done'
    print ' - Checking for tmp directory ... '

    unless Dir.exists? "#{Rails.root}/tmp/#{pid}"
      system "mkdir #{Rails.root}/tmp/#{pid}"
    end

    puts 'done'
  
    image_path = "#{Rails.root}/tmp/#{pid}/#{safe_image_name(image_name)}"

    Net::HTTP.start(host) do |http|

      print "-- Contacting remote #{host}#{path} ... "

      begin
        response = http.get(path)
        puts 'done'
      rescue => error
        puts "ERROR: #{error}"
      end

      print "-- Saving image to #{image_path} ... "

      open(image_path, 'wb') do |file|
        file.write(response.body)
      end

      puts 'done'
    end

    image_path
  end

end
