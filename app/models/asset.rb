class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :position, type: Integer

  has_mongoid_attached_file :image,
    :styles => {
      :tiny       => "100x80",
      :thumbnail  => "100x120",
      :small      => "160x120",
      :medium     => "280x240",
      :large      => "520x480",
      :manage     => "340x313"
    },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :s3_headers => {
      :content_type => 'application/octet-stream',
      :content_disposition => 'attachment'
    },
    :path => "variation/:attachment/:id/:basename-:style.:extension",
    :url => ":s3_domain_url"
  
  embedded_in :variation
end
