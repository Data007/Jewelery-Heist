class ItemsController < ApplicationController
  def index
    begin
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
    rescue
      render template: 'responses/404', status: 404
    end
  end
  
  def show
    begin
      @item = Item.find(params[:id])
    rescue
      render template: 'responses/405', status: 405
    end
  end
end
