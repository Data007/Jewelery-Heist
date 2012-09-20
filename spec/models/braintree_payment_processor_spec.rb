require 'spec_helper'

describe BraintreePaymentProcessor do
  use_vcr_cassette

  before do
    @user = FactoryGirl.create :web_user_with_address
  end

  context 'validating a credit card' do
    before do
      @test_card = {
        number: '4111111111111111',
        expiration_date: '12/14',
        cardholder_name: 'web user'
      }
    end

    it 'fails without a customer id' do
      pending 'waiting on validation for PaymentProcessor'
      response = BraintreePaymentProcessor.store_card(user: @user, credit_card: @test_card)
      response.response_text.should == '91704 Customer ID is required.'
    end

    it 'fails with invalid customer id'
    it 'fails with expiration date if expiration month and year are provided'
    it 'fails with invalid token'
    it 'fails when a credit card token is already taken'
    it 'fails when a credit card token is too long'
    it 'fails when it uses "new" as a token'
    it 'fails when it uses "all" as a token'
    it 'fails without a payment method token'
    it 'fails when the credit card number is too long'
    it 'fails when credit card type is not accepted by the merchant account'
    it 'fails without a cvv'
    it 'fails when cvv is greater than 4'
    it 'fails without an expiration date'
    it 'fails when expiration date is invalid'
    it 'fails when expiration date year is invalid'
    it 'fails when expiration year is invalid'
    it 'fails when expiration month is invalid'
    it 'fails without a credit card number'
    it 'fails with an invalid credit card number'
    it 'fails when the credit card number is less than 12'
    it 'fails when the credit card number is greater than 19'
    it 'fails when update existing token is invalid'
  end

  it 'creates a credit card'
  it 'edits a credit card'
  it 'removes a credit card'
end
