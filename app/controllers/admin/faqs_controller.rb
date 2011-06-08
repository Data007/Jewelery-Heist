class Admin::FaqsController < AdminController
  before_filter :find_faq
  
  def index
    render :template => "admin/faqs/show"
  end
  
  def show
  end

  def edit
  end

  def update
    if @faq.update_attributes params[:faq]
      flash[:notice] = "The FAQ has been updated"
      redirect_to admin_faq_path(@faq)
    else
      flash[:error] = "There was a problem updating the faq. Please try again."
      render :template => "admin/faqs/edit"
    end
  end

  private
    def find_faq
      @faq = Faq.find(:first)
    end
end
