class PagesController < ApplicationController
  def home
    @items = Item.published.listable.paginate(pagination_hash)
  end
  
  def bad_route
    render :template => "responses/404"
  end
end
