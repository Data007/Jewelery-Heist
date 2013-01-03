class AngularTestsController < ApplicationController
  layout 'angular'
  skip_before_filter :current_order
  skip_before_filter :clean_up_order

  before_filter :force_valid_token, only: :items

  def hello_angular
    render text: 'Hello World!'
  end

  def authenticate
    render json: {authenticated: true, token: 'you betcha!'}.to_json
  end

  def items
    render json: [{name: 'ball', cost: '30.5'}, {name: 'house', cost: '80000.00'}].to_json
  end

private
  def force_valid_token
    unless params[:token].present?
      render json: {message: 'You must be logged in'}.to_json, status: 401
    end
  end

end
