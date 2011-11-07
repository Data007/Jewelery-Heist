class CollectionsController < ApplicationController
  def index
    @collections = Collection.all.paginate(pagination_hash.merge({:per_page => 4, :order => "created_at DESC"}))
  end

  def show
    @collection = Collection.where(pretty_id: params[:id].split('-').first).first
  end

end
