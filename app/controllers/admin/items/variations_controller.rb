class Admin::Items::VariationsController < Admin::ItemsController
  before_filter :find_variation, except: [:new]

  def new
    @variation = @item.variations.create
  end

  def edit
  end

  def update
    params[:variation].delete(:id)
    params[:variation].each do |(key, value)|
      eval("@variation.#{key} = '#{value}'")
    end

    if @variation.save
      flash[:notice] = 'The variation has been updated'
      redirect_to [:edit, :admin, @item]
    else
      flash[:error] = 'We could not update the variation'
      render action: :edit
    end
  end

private

  def find_variation
    @variation = @item.variations.find(params[:id])
  end

end
