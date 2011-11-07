class CollectionsController < ApplicationController
  def index
    @collections = Collection.all.paginate(pagination_hash.merge({:per_page => 4, :order => "created_at DESC"}))
  end

  def show
    if params[:id].match('-').present?
      @collection = Collection.where(custom_id: params[:id].split('-').first.to_i).first
    else
      @collection = Collection.where(pretty_id: params[:id]).first
    end
  end

end
