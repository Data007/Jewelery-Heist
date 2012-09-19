require 'spec_helper'

describe Phone do
  context 'with a phone number' do
    before do
      @user  = FactoryGirl.create :user
      @phone = FactoryGirl.create :phone, user: @user
    end

    it 'validates it puts in a correct phone number' do
      @phone.update_attributes!(number: '2319203456')
      @phone.reload.number.should == '2319203456'

      ->{@phone.update_attributes!(number: '23')}.should raise_error(Mongoid::Errors::Validations)
      @phone.reload
      @phone.number.should == '2319203456'

      ->{@phone.update_attributes!(number: '23192088776')}.should raise_error(Mongoid::Errors::Validations)
      @phone.reload
      @phone.number.should == '2319203456'

      @phone.update_attributes!(number: '(231)884-3024')
      @phone.reload
      @phone.number.should == '(231)884-3024'

      @phone.update_attributes!(number: '2318843024')
      @phone.reload
      @phone.number.should == '2318843024'

      @phone.update_attributes!(number: '231.884.3024')
      @phone.reload
      @phone.number.should == '231.884.3024'
    end
  end
end
