class Admin::SearchesController < AdminController
  
  def general
    @query = params[:search][:query]
    @items = Item.search(@query)
    @items = @items.present? ? @items.paginate(pagination_hash) : [].paginate(pagination_hash)
    @title = "Listing #{@query} Results"

    if @items.length > 1 || @items.length < 1
      template = "admin/items/index"
    else
      template = "admin/items/show"
      @item = @items.first
    end
    
    render :template => template
  end

end
