class Admin::MoldsController < AdminController
  def index
    @molds = Mold.paginate(pagination_hash)
  end
  
  def new
    begin
      @current_user.may_create_mold! Mold.new
      @mold = Mold.create
    rescue
      flash[:error] = "You do not have permission to create molds"
      redirect_to admin_molds_path
    end
  end
  
  def cancel
    begin
      @current_user.may_cancel_mold! Mold.new
      Mold.find(params[:id]).destroy
    rescue
      flash[:error] = "You do not have permission to create or cancel molds"
    end
    redirect_to admin_molds_path
  end
  
  def create
    begin
      @mold = Mold.find(params[:mold][:id])
      @current_user.may_create_mold! @mold
      if @mold.update_attributes params[:mold]
        flash[:notice] = "Your mold has been created."
        redirect_to admin_mold_path(@mold.id)
      else
        flash[:error] = "We could not create your mold. Please try again."
        render :template => "admin/molds/new"
      end
    rescue
      flash[:error] = "You do not have permission to create a mold"
      redirect_to admin_molds_path
    end
  end
  
  def edit
    begin
      @mold = Mold.find(params[:id])
      @current_user.may_edit_mold! @mold
    rescue
      flash[:error] = "You do not have permission to edit molds"
      redirect_to admin_mold_path(params[:id])
    end
  end
  
  def update
    begin
      @mold = Mold.find(params[:mold][:id])
      @current_user.may_edit_mold! @mold
      if @mold.update_attributes params[:mold]
        flash[:notice] = "Your mold has been updated."
        redirect_to admin_mold_path(@mold.id)
      else
        flash[:error] = "We could not update your mold. Please try again."
        render :template => "admin/molds/edit"
      end
    rescue
      flash[:error] = "You do not have permission to edit molds"
      redirect_to admin_mold_path(params[:mold][:id])
    end
  end
  
  def show
    @mold = Mold.find(params[:id])
  end
  
  def destroy
    begin
      @current_user.may_cancel_mold! Mold.new
      Mold.find(params[:id]).destroy
      redirect_to admin_molds_path
    rescue
      flash[:error] = "You do not have permission to create or cancel molds"
      redirect_to admin_mold_path(params[:id])
    end
  end
end
