require 'spec_helper'

describe CreditCard do
  context 'with a credit card' do
    before do
      @user = FactoryGirl.create :user
      @card = FactoryGirl.create :credit_card, user: @user
    end

    it 'validates credit card number length' do
      #check that we can change the number
      @card.update_attribute(:number, 1234567890123456)
      @card.number.should == 1234567890123456
      
      #check that the number is not too short
      @card.update_attribute(:number, 12)
      @card.reload
      @card.number.should_not == 12
      @card.number.should == 1234567890123456

      #check that the number is not too long
      @card.update_attribute(:number, 12345678901234567890)
      @card.reload
      @card.number.should_not == 12345678901234567890
      @card.number.should == 1234567890123456
    end
  end
end
