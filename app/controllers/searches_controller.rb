class SearchesController < ApplicationController
  def show
    @query = params[:q]
    @items = Item.search(@query)
    @items = @items.present? ? @items.paginate(pagination_hash) : [].paginate(pagination_hash)
    @title = "Listing #{@query} Results"

    if @items.length > 1 || @items.length < 1
      template = "items/index"
    else
      template = "items/show"
      @item = @items.first
    end
    
    render :template => template
  end
end
