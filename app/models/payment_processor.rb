class PaymentProcessor

  class << self
    def validate_card(options={card_number: '', card_month: '', card_year: '', card_cvv: '', card_type: '', full_name: ''})
      CreditCardValidator::Validator.options[:test_numbers_are_valid] = true if Rails.env.test?
      return CreditCardValidator::Validator.valid?(options[:card_number].to_s)
    end
  end
end
