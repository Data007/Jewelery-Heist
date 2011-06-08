class Admin::CollectionsController < AdminController
  def index
    @collections = Collection.the_living.paginate(pagination_hash)
  end
  
  def new
    @collection = Collection.new
  end
  
  def create
    @collection = Collection.new(params[:collection])
    if @collection.save
      flash[:notice] = "Your collection has been saved"
      redirect_to admin_collection_path(@collection.id)
    else
      flash[:error] = "There was an error creating your collection"
      render :template => "admin/collections/new"
    end
  end
  
  def show
    @collection = Collection.find(params[:id])
  end
  
  def edit
    @collection = Collection.find(params[:id])
  end
  
  def update
    @collection = Collection.find(params[:id])
    if @collection.update_attributes(params[:collection])
      flash[:notice] = "Your collection has been updated"
      redirect_to admin_collection_path(@collection.id)
    else
      flash[:error] = "There was an error updating your collection"
      render :template => "admin/collections/edit"
    end
  end
  
  def destroy
    begin
      @current_user.may_destroy_collection! Collection.new
      Collection.find(params[:id]).destroy
      redirect_to admin_collections_path
    rescue
      flash[:error] = "You do not have permission to create or cancel collections"
      redirect_to admin_collection_path(params[:id])
    end
  end
end
