class PagesController < ApplicationController
  def home
    @items = Item.published.listable[0..4]
  end
  
  def bad_route
    render :template => "responses/404"
  end
end
