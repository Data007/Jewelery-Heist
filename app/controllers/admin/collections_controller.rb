class Admin::CollectionsController < AdminController
  before_filter :find_collection, except: [:index, :new]

  def index
    @collections = Collection.all
  end

  def new
    @collection = Collection.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
    redirect_to :back
  end

private

  def find_collection
    @collection = Collection.find(params[:id])
  end

end
