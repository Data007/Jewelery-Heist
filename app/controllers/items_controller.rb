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
    item_id, custom_id = params[:id].match(/^(\d+)(-)?/).captures

    begin
      if custom_id
        @item = Item.where(custom_id: item_id.to_i)
        @item = @item.present? ? @item.first : render(template: 'responses/404') and return
        @current_variation = params[:variation_id] ? @item.variations.where(custom_id: params[:variation_id].to_i).first : nil
      else
        @item = Item.where(pretty_id: item_id.to_i)
        @item = @item.present? ? @item.first : render(template: 'responses/404') and return
        @current_variation = params[:variation_id] ? @item.variations.where(pretty_id: params[:variation_id].to_i).first : nil
      end
    rescue
      render template: 'responses/404'
    end

    # begin
    #   @item = Item.where(pretty_id: params[:id]).first
    #   @current_variation = params[:variation_id] ? @item.variations.where(pretty_id: params[:variation_id]).first : nil
    # rescue
    #   begin
    #     @item = Item.where(custom_id: params[:id]).first
    #     if @item && @item.variations
    #       @current_variation = params[:variation_id] ? @item.variations.where(pretty_id: params[:variation_id]).first : nil
    #     else
    #       render :template => "responses/404"
    #     end
    #   rescue
    #     render :template => "responses/404"
    #   end
    # rescue
    #   render :template => "responses/404"
    # end

  end
end
