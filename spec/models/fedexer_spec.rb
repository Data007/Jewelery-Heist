require 'spec_helper'

describe Fedexer do
  use_vcr_cassette

  context 'with a fedexer' do
    before do
      @user = FactoryGirl.create :web_user_with_address
    end

    it 'validates recipient' do
      address = @user.addresses.first

      Fedexer.recipient(@user.name, @user.addresses.first, @user.phones.first.number).should == {
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

    context 'with a country code' do
      before do
        @code = 'CA'
      end

      it 'gets a country list' do
        provinces = Fedexer.provinces(@code)
        provinces.should include(["Alberta", "AB"])
        provinces.should include(["British Columbia", "BC"])
        provinces.should include(["Manitoba", "MB"])
        provinces.should include(["New Brunswick", "NB"])
        provinces.should include(["Newfoundland and Labrador", "NL"])
        provinces.should include(["Nova Scotia", "NS"])
        provinces.should include(["Northwest Territories", "NT"])
        provinces.should include(["Nunavut", "NU"])
        provinces.should include(["Ontario", "ON"])
        provinces.should include(["Prince Edward Island", "PE"])
        provinces.should include(["Quebec", "QC"])
        provinces.should include(["Saskatchewan", "SK"])
        provinces.should include(["Yukon Territory", "YT"])
      end
    end


    context 'with a package' do
      before do
        @packages = [
          {
            weight: {units: 'LB', value: 2},
            dimensions: {length: 10, width: 5, height: 4, units: 'IN'}
          }]
      end

      it 'gets a rate Fedex Ground Rate' do
        rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@user.name, @user.addresses.first, @user.phones.first.number), @packages, 'FEDEX_GROUND', Fedexer.default_shipping_details) 
        rate.should be_an_instance_of(Fedex::Rate)
      end

      it 'gets an OverNight Rate' do
        rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@user.name, @user.addresses.first, @user.phones.first.number), @packages, 'STANDARD_OVERNIGHT', Fedexer.default_shipping_details) 
        rate.should be_an_instance_of(Fedex::Rate)
      end

      it 'gets an 2 Day Rate' do
        rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@user.name, @user.addresses.first, @user.phones.first.number), @packages, 'FEDEX_2_DAY', Fedexer.default_shipping_details) 
        rate.should be_an_instance_of(Fedex::Rate)
      end

      it 'gets a standard express rate' do
        rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@user.name, @user.addresses.first, @user.phones.first.number), @packages, 'FEDEX_EXPRESS_SAVER', Fedexer.default_shipping_details) 
        rate.should be_an_instance_of(Fedex::Rate)
      end

      context 'with an international address' do
        before do
          @user = FactoryGirl.create :web_user_with_international_europe_address
        end

        it 'gets an international economy rate' do
          rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@user.name, @user.addresses.first, @user.phones.first.number), @packages, 'INTERNATIONAL_ECONOMY', Fedexer.default_shipping_details) 
          rate.should be_an_instance_of(Fedex::Rate)
        end

        it 'gets an international priority rate' do
          rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@user.name, @user.addresses.first, @user.phones.first.number), @packages, 'INTERNATIONAL_PRIORITY', Fedexer.default_shipping_details) 
          rate.should be_an_instance_of(Fedex::Rate)
        end
      end

      context 'with an english address' do
        before do
          @user = FactoryGirl.create :web_user_with_international_europe_address
        end

        it 'gets a europe rate' do
          rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@user.name, @user.addresses.first, @user.phones.first.number), @packages, 'INTERNATIONAL_PRIORITY', Fedexer.default_shipping_details) 
          rate.should be_an_instance_of(Fedex::Rate)
        end
      end

      context 'with multiple packages' do
        before do
         @packages = [
            {
              weight: {units: 'LB', value: 2},
              dimensions: {length: 10, width: 5, height: 4, units: 'IN'}
            },
            {
              weight: {units: 'LB', value: 4},
              dimensions: {length: 10, width: 5, height: 4, units: 'IN'}
            }
          ]
        end

        it 'gets a Fedex Ground Rate' do
          rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@user.name, @user.addresses.first, @user.phones.first.number), @packages, 'STANDARD_OVERNIGHT', Fedexer.default_shipping_details) 
          rate.should be_an_instance_of(Fedex::Rate)
        end
      end

      context 'with a cart object' do
        before do
          @cart = FactoryGirl.create :anonymous_cart_ready_for_payments
        end

        it 'gets a rate' do
          rate = Fedexer.get_rate(Fedexer.shipment, Fedexer.recipient(@cart.first_name + " " + @cart.last_name, @cart.shipping_address, @cart.phone), Fedexer.sample_package, 'FEDEX_EXPRESS_SAVER', Fedexer.default_shipping_details) 
          rate.should be_an_instance_of(Fedex::Rate)
        end

        it 'gets a rate from the cart instance method' do
          rate = @cart.get_rate 'FEDEX_EXPRESS_SAVER'
          rate.should be_an_instance_of(Fedex::Rate)
        end
      end
    end
  end
end
