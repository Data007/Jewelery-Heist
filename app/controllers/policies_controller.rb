class PoliciesController < ApplicationController
  def delivery
  end

  def return
  end

  def privacy
  end
  
  def faq
    @faq = Faq.first
  end

end
