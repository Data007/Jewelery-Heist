class Admin::ItemsController < AdminController
  def index
    @items = Item.completed.listable.paginate(pagination_hash)
  end
  
  def current
    @items = Item.listable.paginate(pagination_hash)
    render :template => "admin/items/index"
  end
  
  def old
    @items = Item.not_available.paginate(pagination_hash)
    render :template => "admin/items/index"
  end
  
  def instore
    @items = Item.listable.unpublished.paginate(pagination_hash)
    render :template => "admin/items/index"
  end
  
  def published
    @items = Item.listable.published.paginate(pagination_hash)
    render :template => "admin/items/index"
  end
  
  def ooak
    @items = Item.listable.ooak.paginate(pagination_hash)
    render :template => "admin/items/index"
  end
  
  def find
    if params[:id] =~ /^\d+$/
      @item = Item.find(params[:id])
      redirect_to admin_item_path(@item.id)
    elsif params[:id] =~ /^ID\d+\-\d+$/ || params[:id] =~ /^\d+\-\d+$/ || params[:id] =~ /^id\d+\-\d+$/
      item_id, variation_id = params[:id].gsub("ID","").gsub("id","").split("-")
      @item = Item.find(item_id)
      @variation = Variation.find(variation_id)
      redirect_to admin_item_path(:id => @item.id, :variation_id => @variation.id)
    end
  end
  
  def new
    @item = Item.create
  end
  
  def cancel
    Item.find(params[:id]).destroy
    redirect_to admin_root_path
  end
  
  def create
    @item = Item.find(params[:item][:id])
    if @item.update_attributes params[:item]
      flash[:notice] = "Your item has been saved. Please add a variation."
      redirect_to new_admin_item_variation_path(@item)
    else
      flash[:error] = "There was a problem creating your item"
      render :template => "items/new"
    end
  end
  
  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      format.html do
        if @item.update_attributes params[:item]
          flash[:notice] = "Your item has been updated"
          redirect_to admin_item_path(@item)
        else
          flash[:error] = "There was a problem updating your item"
          render :template => "admin/items/edit"
        end
      end
      format.json { render :json => @item.to_json }
    end
  end
  
  def show
    @item = Item.find(params[:id])
    @variation = params[:variation_id] ? Variation.find(params[:variation_id]) : nil
  end
  
  def destroy
    begin
      @current_user.may_destroy_item! Item.new
      Item.find(params[:id]).destroy
      redirect_to admin_item_path(params[:id])
    rescue
      flash[:error] = "You do not have permission to create or cancel items"
      redirect_to admin_item_path(params[:id])
    end
  end
  
  def restore
    begin
      @current_user.may_destroy_item! Item.new
      Item.find(params[:id]).resurrect
      flash[:notice] = "Your item has been restored"
      redirect_to admin_item_path(params[:id])
    rescue
      flash[:error] = "We could not restore your item"
      redirect_to admin_item_path(params[:id])
    end
  end
end
