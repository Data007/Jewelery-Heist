class Admin::SearchesController < AdminController
  
  def general
    @query = params[:search][:query]
    @items = Item.search(@query)
    @items = @items.present? ? @items.paginate(pagination_hash) : []

    redirect_to admin_item_path(@items.first.id) if (@item && @items.length == 1) and return

    @title = "Listing results for: #{@query}"
    render template: "admin/items/index"
  end

end
