require 'spec_helper'

describe CreditCard do
  before do
    @user = FactoryGirl.create :user
    @card = FactoryGirl.create :credit_card, user: @user
  end

  it 'has a custom validation' do
    ->{@card.update_attributes! ccv: ''}.should raise_error(Mongoid::Errors::Validations)
  end
  pending 'Actual tests needed'
end
