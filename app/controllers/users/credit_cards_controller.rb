class Users::CreditCardsController < ApplicationController
  before_filter :force_login
  before_filter :find_credit_card, except: [:new, :create, :index]

  def new
    @credit_card = @current_user.credit_cards.new
  end

  def create
    @credit_card = @current_user.credit_cards.create(params[:credit_card])
    redirect_to [:profile]
  end

  def update
    @credit_card.update_attributes params[:credit_card]
    redirect_to [:profile] 
  end

  def destroy
    @current_user.credit_cards.find(params[:id]).destroy
    redirect_to [:profile]
  end

  private
  def find_credit_card
    credit_card_id = params[:credit_card_id] ? params[:credit_card_id] : params[:id]
    @credit_card = @current_user.credit_cards.find(credit_card_id)
  end
end
