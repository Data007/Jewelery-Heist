class Admin::SearchesController < AdminController
  
  def general
    @query = params[:search][:query]
    @items = Item.search(@query).paginate(pagination_hash)

    redirect_to admin_item_path(@items.first.id) if (@item && @items.length == 1) and return

    @title = "Listing results for: #{@query}"
    render template: "admin/items/index"

    # if params[:search][:query] =~ /^\d+$/
    #   @item = Item.where(old_id: params[:search][:query]).first
    #   redirect_to admin_item_path(@item.id)
    # elsif params[:search][:query] =~ /^ID\d+\-\d+$/ || params[:search][:query] =~ /^\d+\-\d+$/ || params[:search][:query] =~ /^id\d+\-\d+$/
    #   item_id, variation_id = params[:search][:query].gsub("ID","").gsub("id","").split("-")
    #   @item = Item.find(item_id)
    #   @variation = Variation.find(variation_id)
    #   redirect_to admin_item_path(:id => @item.id, :variation_id => @variation.id)
    # else
    #   @items = Item.search(params[:search][:query]).paginate(pagination_hash)
    #   @title = "Listing #{params[:search][:query].capitalize} Results"
    #   @query = params[:search][:query]
    #   render :template => "admin/items/index"
    # end  
  end

end
