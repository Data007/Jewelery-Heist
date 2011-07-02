# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def button_for_url(text, url, options={})
    raise "No Text Provided" unless text
    raise "No URL provided" unless url
    button_class  = options[:class]
    button_id     = options[:id]
    html  = "<span"
    html += " id='#{button_id}'" if button_id
    html += " class='#{button_class}'" if button_class
    html += "><a href='#{url}'>#{text}</a></span>"
    return html
  end
  

end
