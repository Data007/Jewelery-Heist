class ColorsController < ApplicationController
  def show
    @items = Item.with_color(params[:id]).listable.published.paginate(pagination_hash)
    if @items.length > 1 or @items.length < 1
      render :template => "items/index"
    else
      @item = @items.first
      @variation = @item.variations.where(:'color.names' => Regexp.new(params[:id])).first
      render :template => "items/show"
    end
  end
end
