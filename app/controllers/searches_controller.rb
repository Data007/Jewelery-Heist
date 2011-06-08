class SearchesController < ApplicationController
  def show
    results = Item.search(params[:q]).published.listable.paginate(pagination_hash)
    
    if results.length > 1 or results.length < 1
      template = "items/index"
      @items = results
    else
      template = "items/show"
      @item = results.first
    end
    
    @title = "Listing #{params[:q].capitalize} Results"
    @query = params[:q]
    render :template => template
  end
end
