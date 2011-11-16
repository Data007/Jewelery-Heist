class Admin::Items::Variations::AttachmentsController < Admin::Items::VariationsController

  def create
    asset = @variation.assets.new({position: @variation.assets.length + 1})
        
    asset.image = params[:image]
    asset.save
  
    response = {
      status:          "ok",
      original_path:   asset.image.url(:original),
      delete_path:     admin_item_variation_attachment_path(@item.pretty_id, @variation.pretty_id, asset.id),
      name:            asset.image_file_name,
      path:            asset.image.url(:manage),
      parent_image_id: "image_#{asset.id}"
    }
    render :text => response.to_json
  end
  
  def update_position
    asset = @variation.assets.find(params[:id])
    @variation.update_asset_position(asset, params[:position])
  end

  def destroy
    @asset = @variation.assets.find(params[:id])
    @asset.destroy
    respond_to do |format|
      format.html {}
      format.json {render :json => @asset.to_json}
    end
  end

end
