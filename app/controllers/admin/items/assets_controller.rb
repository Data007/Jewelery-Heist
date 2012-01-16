class Admin::Items::AssetsController < Admin::ItemsController
  before_filter :find_item

  def create
    asset = @item.assets.new
        
    asset.image = params[:image]
    asset.save
  
    response = {
      status:          "ok",
      original_path:   asset.image.url(:original),
      delete_path:     admin_item_assets_path(@item.pretty_id, asset.id),
      name:            asset.image_file_name,
      path:            asset.image.url(:manage),
      parent_image_id: "image_#{asset.id}"
    }
    render :text => response.to_json
  end
  
  def update_position
    asset = @item.assets.find(params[:id])
    @item.update_asset_position(asset, params[:position])
    render text: 'ok'
  end

  def destroy
    @asset = @item.assets.find(params[:id])
    @asset.destroy
    respond_to do |format|
      format.html {}
      format.json {render :json => @asset.to_json}
    end
  end

private
  
  def find_item
    @item = Item.find(params[:item_id])
  end

end
