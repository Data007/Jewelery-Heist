require 'spec_helper'
#require 'fedexer'

describe Fedexer do
  use_vcr_cassette
  context 'with a fedexer' do
    before do
      @user = FactoryGirl.create :web_user_with_address
    end

    it 'validates recipient' do
      address = @user.addresses.first

      Fedexer.recipient(@user, @user.addresses.first, @user.phones.first).should == {
       name: @user.name,
       phone_number: @user.phones.first.number,
       address: address.address_1,
       city: address.city, 
       state: address.province,
       postal_code: address.postal_code,
       country_code: address.country,
       residential: 'false'
      } 
    end 

    it 'validates sample package' do
      Fedexer.sample_package.should == 
      [{
        weight: {units: 'LB', value: 2},
        dimensions: {length: 10, width: 5, height: 4, units: 'IN'}
      }]
    end

    it 'gets a rate' do
      rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@user, @user.addresses.first, @user.phones.first), Fedexer.sample_package, 'FEDEX_GROUND') 
    end
  end
end
