class CollectionsController < ApplicationController
  def index
    @collections = Collection.all.paginate(pagination_hash.merge({:per_page => 4, :order => "created_at DESC"}))
  end

  def show
    id = params[:id].split('-').first
    @collection = Collection.where(pretty_id: id)
    @colelction = @collection.present? ? @collection.first : Collection.where(pretty_id: id).first
  end

end
