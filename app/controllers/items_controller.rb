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
    begin
      @item = Item.find(params[:id])
      @current_variation = params[:variation_id] ? @item.variations.find(params[:variation_id]) : nil
    rescue ActiveRecord::RecordNotFound
      begin
        @item = Item.find(:first, :conditions => {:custom_id => params[:id]})
        if @item && @item.variations
          @current_variation = params[:variation_id] ? @item.variations.find(params[:variation_id]) : nil
        else
          render :template => "responses/404"
        end
      rescue
        render :template => "responses/404"
      end
    rescue
      render :template => "responses/404"
    end
  end
end
