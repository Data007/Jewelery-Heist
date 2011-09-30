class ColorsController < ApplicationController
  def show
    @color = Color.find(params[:id])
    @items = @color.variations.listable.published.paginate(pagination_hash)
    if @items.length > 1 or @items.length < 1
      render :template => "items/index"
    else
      @item = @items.first
      @variation = @item.variations.the_living.collect{|v| v if v.color_ids.include?(@color.id)}.compact.first
      render :template => "items/show"
    end
  end
end
