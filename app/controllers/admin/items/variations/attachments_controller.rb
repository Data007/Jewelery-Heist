class Admin::Items::Variations::AttachmentsController < Admin::Items::VariationsController
  
  def update_position
    asset = @variation.assets.find(params[:id])
    @variation.update_asset_position(asset, params[:position])
  end

end
