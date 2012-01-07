Paperclip.options[:swallow_stderr] = false
Paperclip.options[:image_magick_path] = "/usr/local/bin" if Rails.env.development?
