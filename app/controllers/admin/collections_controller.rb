class Admin::CollectionsController < AdminController
  before_filter :find_collection, except: [:index, :new, :create]

  def index
    @collections = Collection.all.paginate(pagination_hash)
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new params[:collection]
    if @collection.save
      flash[:notice] = "#{@collection.name} has been saved"
      redirect_to [:admin, @collection] and return
    else
      flash[:error] = "#{@collection.name} has not been saved"
      render template: 'admin/collections/new'
    end
  end

  def edit
  end

  def update
    if @collection.update_attributes params[:collection]
      flash[:notice] = "#{@collection.name} has been saved"
      redirect_to [:admin, @collection] and return
    else
      flash[:error] = "#{@collection.name} has not been saved"
      render template: 'admin/collections/edit'
    end
  end

  def show
  end

  def destroy
    name = @collection.name
    @collection.destroy
    flash[:notice] = "#{name} has been removed"
    redirect_to [:admin, :collections]
  end

private

  def find_collection
    @collection = Collection.find(params[:id])
  end

end
