class Admin::ItemsController < AdminController

  before_filter :find_item, :except => [:index]
  
  def show
  end

  def edit
  end

  def update
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

private

  def find_item
    @item = params[:item_id] ? Item.find(params[:item_id]) : Item.find(params[:id])
  end
end
