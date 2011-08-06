class Admin::LiveSearchesController < AdminController
  def metals
    metals = VariationMetal.unique_like_to_json(params[:id])
    render :text => metals
  end
  
  def finishes
    finishes = VariationFinish.unique_like_to_json(params[:id])
    render :text => finishes
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
