class Admin::Items::VariationsController < Admin::ItemsController
  before_filter :find_item
  before_filter :find_variation, except: [:new]

  def new
    @variation = @item.variations.create
  end

  def edit
  end

  def update
    params[:variation].delete(:id)

    if @variation.update_attributes params[:variation]
      flash[:notice] = 'The variation has been updated'
      redirect_to edit_admin_item_variation_path(@item.pretty_id, @variation.pretty_id)
    else
      flash[:error] = 'We could not update the variation'
      render action: :edit
    end
  end

  def destroy
    @variation.update_attribute(:archived, true) if @variation
    render json: {status: 'ok'}.to_json
  end

private

  def find_variation
    variation_id = params[:variation_id] || params[:id]
    @variation   = @item.variations.where(pretty_id: variation_id, :'archived'.in => [true, false]).first
  end

end
