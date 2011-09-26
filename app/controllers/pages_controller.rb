class PagesController < ApplicationController
  def home
    # save_previous_page
    @items = Item.published.listable.paginate(pagination_hash)
  end
  
  def about
    # save_previous_page
  end
  
  def bad_route
    render :template => "responses/404"
  end
end
