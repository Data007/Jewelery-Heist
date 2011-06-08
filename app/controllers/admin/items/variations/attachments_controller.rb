class Admin::Items::Variations::AttachmentsController < AdminController
  def create
    variation = Variation.find(params[:variation_id])
    asset = Asset.new({:position => variation.assets.length + 1})
    
    variation.assets << asset
    variation.save
    
    asset.image = params[:image]
    asset.save
  
    response = {
      :status => "ok",
      :original_path    => asset.image.url(:original),
      :delete_path      => admin_item_variation_attachment_path(:item_id =>variation.item.id, :variation_id => variation.id, :id => asset.id),
      :name             => asset.image_file_name,
      :path             => asset.image.url(:manage),
      :parent_image_id  => "image_#{asset.id}"
    }
    render :text => response.to_json
  end
  
  def update_positions
    assets = Variation.find(params[:variation_id]).assets.by_position.map {|a| a.id.to_i}
    assets.delete(params[:id].to_i)
    assets.insert(params[:position].to_i, params[:id].to_i)
    assets.each_index {|i| Asset.find(assets[i]).update_attributes :position => i}
    render :nothing => true
  end
  
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    respond_to do |format|
      format.html {}
      format.json {render :json => @asset.to_json}
    end
  end
end
