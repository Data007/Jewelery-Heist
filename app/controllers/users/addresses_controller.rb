class Users::AddressesController < UsersController
    before_filter :find_address, except: [:new, :create, :index]
  def new
    @address = @current_user.addresses.new
  end

  def create
    @address = @current_user.addresses.create params[:address]
    redirect_to [:profile]
  end

  def edit
  end

  def update
    @address.update_attributes params[:address]
    redirect_to [:profile]
  end
  
  private
  def find_address
    address_id = params[:address_id] ? params[:address_id] : params[:id]
    @address = @current_user.addresses.find(address_id)
  end
end
