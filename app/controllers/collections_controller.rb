class CollectionsController < ApplicationController
  def index
    @collections = Collection.all.paginate(pagination_hash.merge({:per_page => 4, :order => "created_at DESC"}))
  end

  def show
    @collection = Collection.find(params[:id])
  end

end
