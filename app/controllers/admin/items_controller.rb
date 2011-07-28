class Admin::ItemsController < AdminController
  
  def show
    @item = Item.find(params[:id])
  end

  def index
    @items = Item.all.paginate(pagination_hash)
  end
end
