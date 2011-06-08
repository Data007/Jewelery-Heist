class Asset < ActiveRecord::Base
  # acts_as_audited
  Paperclip.interpolates :attachable_class do |attachment, style|
    attachment.instance.attachable.class.to_s.downcase
  end
  
  belongs_to :attachable, :polymorphic => true
  scope :by_position, :order => "position ASC"
  has_attached_file :image,
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
    :path => ":attachable_class/:attachment/:id/:basename-:style.:extension",
    :url => ":s3_domain_url"
end
