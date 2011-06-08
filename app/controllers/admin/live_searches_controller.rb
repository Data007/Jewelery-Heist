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
    jewels = VariationGem.unique_like_to_json(params[:id])
    render :text => jewels
  end
  
  def molds
    molds = Variation.molds_unique_like_to_json(params[:id])
    render :text => molds
  end
end
