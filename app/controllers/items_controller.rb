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
      @item = Item.where(pretty_id: params[:id]).first
    rescue
      render template: 'responses/404'
    end
  end
end
