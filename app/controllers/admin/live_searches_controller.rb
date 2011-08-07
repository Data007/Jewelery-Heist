class Admin::LiveSearchesController < AdminController
  def metals
    metals = Variation.metals_like(params[:id])
    render :text => metals.to_json
  end
  
  def finishes
    finishes = Variation.finishes_like(params[:id])
    render :text => finishes.to_json
  end
  
  def jewels
    jewels = Variation.jewels_like(params[:id])
    render :text => jewels.to_json
  end
  
  def molds
    molds = Variation.molds_unique_like_to_json(params[:id])
    render :text => molds
  end
  
end
