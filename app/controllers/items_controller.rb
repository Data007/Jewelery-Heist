class ItemsController < ApplicationController
  def index
    @items = Item.published.listable.paginate(pagination_hash)
    respond_to do |format|
      format.js {render :partial => "items/thumbnail", :collection => @items}
      format.json do
        render :json => (@items.collect {|item|
          item.id
        }).to_json
      end
      format.html {}
    end
  end
  
  def show
    # TODO: Replace with a normal lookup; kill backwards compatibility with old ids
    item_id, custom_id = params[:id].match(/^(\d+)(\S+)?/).captures

    begin
      if custom_id
        @item = Item.where(custom_id: item_id.to_i)
        @item = @item.first
        @current_variation = params[:variation_id] ? @item.variations.where(custom_id: params[:variation_id].to_i).first : nil
      else
        @item = Item.where(pretty_id: item_id.to_i)
        @item = @item.first
        @current_variation = params[:variation_id] ? @item.variations.where(pretty_id: params[:variation_id].to_i).first : nil
      end
    rescue
      render template: 'responses/404'
    end
  end
end
