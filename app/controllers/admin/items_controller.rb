class Admin::ItemsController < AdminController
  
  def show
    @item = Item.find(params[:id])
  end
end
