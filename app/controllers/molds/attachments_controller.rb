class Molds::AttachmentsController < AdminController
  def create
    mold = Mold.find(params[:mold_id])
    asset = Asset.new({:position => mold.assets.length + 1})
    mold.assets << asset
    mold.save
    
    asset.image = params[:image]
    asset.save
    
    response = {
      :status => "ok",
      :original_path    => asset.image.url(:original),
      :download_path    => download_admin_mold_attachment_path(:mold_id => mold.id, :id => asset.id),
      :delete_path      => admin_mold_attachment_path(:mold_id => mold.id, :id => asset.id),
      :name             => asset.image_file_name,
      :path             => asset.image.url(:manage),
      :parent_image_id  => "image_#{asset.id}"
    }
    render :text => response.to_json
  end
  
  def update_positions
    assets = Mold.find(params[:mold_id]).assets.by_position.map {|a| a.id.to_i}
    assets.delete(params[:id].to_i)
    assets.insert(params[:position].to_i, params[:id].to_i)
    assets.each_index {|i| Asset.find(assets[i]).update_attributes :position => i}
    render :nothing => true
  end
  
  def download
    asset = Asset.find(params[:id])
    send_data File.new(asset.image.path(:original), "r").read, :type => asset.image_content_type, :filename => asset.image_file_name
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
