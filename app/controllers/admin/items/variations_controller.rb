class Admin::Items::VariationsController < AdminController
  def index
    @variation = Item.find(params[:item_id]).variations
  end
  
  def new
    @variation = Variation.create(:item_id => Item.find(params[:item_id]).id)
  end
  
  def cancel
    Variation.find(params[:id]).destroy
    redirect_to edit_admin_item_path(params[:item_id])
  end
  
  def create
    @variation = Variation.find(params[:variation][:id])
    item = Item.find(params[:item_id])
    if @variation.update_attributes params[:variation]
      item.variations << @variation
      flash[:notice] = "The variation has been created."
      redirect_to edit_admin_item_path(item)
    else
      flash[:error] = "We couldn't create the variation. Please try again."
      render :action => "new"
    end
  end
  
  def show
    @variation = Variation.find(params[:id])
  end
  
  def edit
    @variation = Variation.find(params[:id])
  end
  
  def update
    params[:variation].delete(:assets_attributes)
    @variation = Variation.find(params[:id])
    
    if @variation.update_attributes params[:variation]
      flash[:notice] = "The variation was updated."
      redirect_to edit_admin_item_path(@variation.item)
    else
      flash[:error] = "We couldn't upgrade your variation. Please try again."
      render :action => "edit"
    end
  end
  
  def destroy
    Variation.find(params[:id]).destroy
    flash[:notice] = "Your variation (ID#{params[:id]}) was destroyed successfully."
    if Item.find(params[:item_id]).variations.length > 1
      redirect_to edit_admin_item_path(params[:item_id])
    else
      flash[:notice] += " There are no variations left so we have to create a new one. Please fill in the variations details below."
      redirect_to new_admin_item_variation_path(:item_id => params[:item_id])
    end
  end
end
