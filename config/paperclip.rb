Paperclip.interpolates :attachable_class do |attachment, style|
  attachment.instance.attachable.class.to_s.downcase
end
Paperclip.options[:swallow_stderr] = false
Paperclip.options[:image_magick_path] = "/usr/local/bin" if RAILS_ENV == "development"