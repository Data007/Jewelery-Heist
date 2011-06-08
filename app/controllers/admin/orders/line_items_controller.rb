class Admin::Orders::LineItemsController < AdminController
  before_filter :force_stage, :only => [:index]
  before_filter :find_order
  
  def index
    if params[:customer]
      options = {:password => "customercare", :login => params[:customer][:name].split(" ").join("-")}
      
      if params[:customer][:email] == nil || params[:customer][:email] == ""
        options[:email] = "order#{current_customer_order.id}@wexfordjewelers.com"
      end
      
      customer = User.find(:first, :conditions => {:name => params[:customer][:name]})
      @customer = customer ? customer : User.create!(params[:customer].merge(options))
      @customer.update_attributes params[:customer]
      
      @order.update_attributes :phones => params[:customer][:phone] unless params[:customer][:phone].blank?
      @order.update_attributes :emails => params[:customer][:email] unless params[:customer][:email].blank?
      
      address = Address.from_hash params[:address]
      
      @customer.add_address address
      
    end
    
    @order.update_attributes params[:order]
    @order.update_attributes :address_1 => params[:address][:address_1], :address_2    => params[:address][:address_2], :city => params[:address][:city], :province => params[:address][:province], :country => params[:address][:country], :postal_code => params[:address][:postal_code] if params[:address]
    
    @customer.orders << @order if params[:customer]
    
    redirect_to admin_order_path(@order)
  end
  
  def create
    if params[:line_item] && params[:line_item][:is_quick_item]
      line_item = LineItem.create(params[:line_item].merge!({:ghost => false}))
    else
      variation = Variation.find(params[:id])
      line_item = LineItem.create(:price => variation.price, :variation_id => variation.id, :quantity => 1, :ghost => false, :size => params[:item_size], :taxable => true)
    end
    
    @order.line_items << line_item
    @order.ticket.current_stage = "adding items"
    respond_to do |format|
      format.html do
        flash[:notice] = "Your item has been added"
        redirect_to admin_order_path(@order)
      end
    end
  end
  
  def update
    line_item.update_attributes params[:line_item]
  end
  
  def destroy
    if params[:refund]
      line_item.refund
    else
      line_item.destroy
    end
    redirect_to :back
  end
  
  private
    def line_item
      return @line_item ||= LineItem.find(params[:id])
    end
    
    def line_item=(new_line_item)
      @line_item = line_item
      return @line_item
    end
end
