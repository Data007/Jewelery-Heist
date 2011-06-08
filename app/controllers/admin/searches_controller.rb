class Admin::SearchesController < AdminController
  def general
    if params[:search][:query] =~ /^\d+$/
      @item = Item.find(params[:search][:query])
      redirect_to admin_item_path(@item.id)
    elsif params[:search][:query] =~ /^ID\d+\-\d+$/ || params[:search][:query] =~ /^\d+\-\d+$/ || params[:search][:query] =~ /^id\d+\-\d+$/
      item_id, variation_id = params[:search][:query].gsub("ID","").gsub("id","").split("-")
      @item = Item.find(item_id)
      @variation = Variation.find(variation_id)
      redirect_to admin_item_path(:id => @item.id, :variation_id => @variation.id)
    else
      @items = Item.search(params[:search][:query]).paginate(pagination_hash)
      @title = "Listing #{params[:search][:query].capitalize} Results"
      @query = params[:search][:query]
      render :template => "admin/items/index"
    end
  end
  
  def users
    query_address = params[:user][:address].present? ? params[:user].delete(:address) : {}
    query_user = params[:user].present? ? params[:user] : {}
    
    @customers = User.scoped_search(query_address, query_user).paginate(pagination_hash)
    params[:user][:address] = query_address
  end
end
