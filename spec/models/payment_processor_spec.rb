require 'spec_helper'

describe PaymentProcessor do
  context 'credit card validation' do
    before do
      @test_card = {
        full_name:   'test user',
        card_number: 4111111111111111,
        card_month:  12,
        card_year:   14,
        card_cvv:    123,
        card_type:   'Visa'
      }
    end

    it 'passes card number validation' do
      PaymentProcessor.validate_card(@test_card.merge({card_number: 4111111111111112})).should_not be
      PaymentProcessor.validate_card(@test_card).should be
    end
  end
end
