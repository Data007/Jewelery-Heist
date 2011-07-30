class Admin::ItemsController < AdminController
  
  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    if @item.update_attributes(params[:item])
      flash[:notice] = 'The item has been saved'
      redirect_to [:admin, @item]
    else
      flash[:error] = "We couldn't save the item"
      render 'admin/items/edit'
    end
  end

  def index
    @items = Item.all.paginate(pagination_hash)
  end
end
